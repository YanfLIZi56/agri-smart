<template>
    <el-dialog title="实时监控" v-model="visible" width="700px" append-to-body destroy-on-close
        :close-on-click-modal="false" :show-close="false" @closed="handleClosed">
        <div class="rtc-dialog-body">
            <div class="video-wrapper">
                <video ref="videoRef" autoplay playsinline muted controls />
                <div v-if="statusText" class="status-overlay">{{ statusText }}</div>
            </div>

            <div class="stats-panel">
                <div class="stat-item">
                    <span class="stat-label">丢包率</span>
                    <span class="stat-value">{{ stats.packetLoss }}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">码率</span>
                    <span class="stat-value">{{ stats.bitrate }}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">延迟</span>
                    <span class="stat-value">{{ stats.rtt }}</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">抖动</span>
                    <span class="stat-value">{{ stats.jitter }}</span>
                </div>
            </div>
        </div>

        <template #footer>
            <el-button type="primary" :loading="isLoading" :disabled="isStreaming" @click="handleStart">
                {{ isLoading ? '连接中...' : '打开' }}
            </el-button>
            <el-button type="danger" @click="handleClose">
                关闭
            </el-button>
        </template>
    </el-dialog>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import axios from 'axios'

const props = defineProps({
    open: {
        type: Boolean,
        default: false
    },
    rtcUrl: {
        type: String,
        required: true
    }
})

const emit = defineEmits(['update:open', 'close'])

const visible = computed({
    get() { return props.open },
    set(val) { emit('update:open', val) }
})

const videoRef = ref(null)
const isLoading = ref(false)
const isStreaming = ref(false)
const statusText = ref('')
const pc = ref(null)
const statsInterval = ref(null)
const stats = ref({
    packetLoss: '0%',
    bitrate: '0 kbps',
    rtt: '0 ms',
    jitter: '0 ms'
})

const PROXY_PREFIX = '/rtc-api'
const WHEP_URL = computed(() => PROXY_PREFIX + props.rtcUrl + '/whep')

async function handleStart() {
    if (isLoading.value) return
    isLoading.value = true
    statusText.value = ''

    try {
        const stream = await connectWHEP()
        videoRef.value.srcObject = stream
        isStreaming.value = true
        statusText.value = ''
        startStatsUpdate()
    } catch (e) {
        console.error('[RTC] 拉流失败:', e)
        statusText.value = '连接失败: ' + e.message
    } finally {
        isLoading.value = false
    }
}

function connectWHEP() {
    return new Promise(async (resolve, reject) => {
        const peer = new RTCPeerConnection({
            iceServers: [{ urls: 'stun:stun.l.google.com:19302' }]
        })
        pc.value = peer

        peer.addTransceiver('video', { direction: 'recvonly' })

        peer.ontrack = (event) => {
            if (event.streams[0]) {
                resolve(event.streams[0])
            }
        }

        peer.oniceconnectionstatechange = () => {
            console.log('[RTC] ICE状态:', peer.iceConnectionState)
            if (peer.iceConnectionState === 'failed') {
                reject(new Error('ICE 连接失败'))
            }
        }

        try {
            const offer = await peer.createOffer()
            await peer.setLocalDescription(offer)

            await waitForIceGathering(peer)

            const response = await axios({
                method: 'post',
                url: WHEP_URL.value,
                headers: { 'Content-Type': 'application/sdp' },
                data: peer.localDescription.sdp,
                responseType: 'text'
            })

            if (response.status < 200 || response.status >= 300) {
                throw new Error('WHEP 请求失败: ' + response.status)
            }

            const answerSdp = response.data
            await peer.setRemoteDescription(
                new RTCSessionDescription({ type: 'answer', sdp: answerSdp })
            )
        } catch (e) {
            reject(e)
        }
    })
}

function waitForIceGathering(peer) {
    return new Promise((resolve) => {
        if (peer.iceGatheringState === 'complete') {
            resolve()
        } else {
            const check = () => {
                if (peer.iceGatheringState === 'complete') {
                    peer.removeEventListener('icegatheringstatechange', check)
                    resolve()
                }
            }
            peer.addEventListener('icegatheringstatechange', check)
            setTimeout(() => {
                peer.removeEventListener('icegatheringstatechange', check)
                resolve()
            }, 3000)
        }
    })
}

function handleClose() {
    emit('close')
}

function handleClosed() {
    stopStream()
}

function stopStream() {
    if (statsInterval.value) {
        clearInterval(statsInterval.value)
        statsInterval.value = null
    }
    if (pc.value) {
        pc.value.close()
        pc.value = null
    }
    if (videoRef.value) {
        videoRef.value.srcObject = null
        videoRef.value.src = ''
    }
    isStreaming.value = false
    isLoading.value = false
    statusText.value = ''
    stats.value = {
        packetLoss: '0%',
        bitrate: '0 kbps',
        rtt: '0 ms',
        jitter: '0 ms'
    }
}

function startStatsUpdate() {
    if (statsInterval.value) clearInterval(statsInterval.value)
    statsInterval.value = setInterval(async () => {
        if (!pc.value) return
        try {
            const report = await pc.value.getStats()
            let videoStats = null
            let transportStats = null

            report.forEach(stat => {
                if (stat.type === 'inbound-rtp' && stat.mediaType === 'video') {
                    videoStats = stat
                } else if (stat.type === 'transport') {
                    transportStats = stat
                }
            })

            if (videoStats) {
                const loss = videoStats.packetsLost / (videoStats.packetsReceived + videoStats.packetsLost) || 0
                stats.value.packetLoss = (loss * 100).toFixed(1) + '%'

                if (videoStats.bytesReceived && videoStats.timestamp) {
                    const now = performance.now()
                    const bytesDiff = videoStats.bytesReceived - (videoStats.lastBytes || 0)
                    const timeDiff = now - (videoStats.lastTimestamp || now)
                    if (timeDiff > 0) {
                        const bitrate = (bytesDiff * 8) / (timeDiff / 1000) / 1000
                        stats.value.bitrate = bitrate.toFixed(1) + ' kbps'
                    }
                    videoStats.lastBytes = videoStats.bytesReceived
                    videoStats.lastTimestamp = now
                }
            }

            if (transportStats) {
                stats.value.rtt = transportStats.roundTripTime ? (transportStats.roundTripTime * 1000).toFixed(0) + ' ms' : '0 ms'
                stats.value.jitter = transportStats.jitter ? (transportStats.jitter * 1000).toFixed(0) + ' ms' : '0 ms'
            }
        } catch (e) {
            console.error('[RTC] 获取统计失败:', e)
        }
    }, 2000)
}
</script>

<style scoped>
.rtc-dialog-body {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;
}

.video-wrapper {
    position: relative;
    width: 100%;
    max-width: 640px;
    aspect-ratio: 16 / 9;
    background: #000;
    border-radius: 4px;
    overflow: hidden;
}

.video-wrapper video {
    width: 100%;
    height: 100%;
    object-fit: contain;
}

.status-overlay {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: #f56c6c;
    font-size: 14px;
    text-align: center;
    background: rgba(0, 0, 0, .6);
    padding: 8px 16px;
    border-radius: 4px;
}

.stats-panel {
    display: flex;
    gap: 24px;
    flex-wrap: wrap;
    justify-content: center;
    padding: 8px 16px;
    background: #f5f7fa;
    border-radius: 4px;
}

.stat-item {
    text-align: center;
    min-width: 80px;
}

.stat-label {
    display: block;
    font-size: 12px;
    color: #666;
}

.stat-value {
    display: block;
    font-size: 16px;
    font-weight: 500;
    color: #333;
}
</style>