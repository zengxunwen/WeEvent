<template>
<div class="headerBar">
  <div class='navigation'>
    <img src="../assets/image/weEvent.png" alt="" @click='home'>
    <span class='server_title' v-show='!noServer'>群组信息:</span>
    <el-dropdown trigger="click" @command='selectGroup'  v-show='!noServer'>
      <span>{{groupId}} <i class="el-icon-arrow-down el-icon-caret-bottom"></i></span>
      <el-dropdown-menu slot="dropdown">
        <el-dropdown-item v-for='(item, index) in groupList' :key='index' :command='item'>{{item}}</el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
    <span class='server_title' v-show='!noServer'>当前服务:</span>
    <el-dropdown trigger="click" @command='selecServers'  v-show='!noServer'>
      <span>{{server}} <i class="el-icon-arrow-down el-icon-caret-bottom"></i></span>
      <el-dropdown-menu slot="dropdown">
        <el-dropdown-item v-for='(item, index) in servers' :key='index' :command='index'>{{item.name}}</el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
  </div>
  <div class='right_part'>
    <el-popover
      placement="bottom"
      title="WeEvent版本信息"
      width="250"
      trigger="click"
      v-show='!noServer'
      >
      <div id='version'>
        <p class='version_infor'>
          <span class='version_title'>
            Branch:
          </span>
          <span class='version_content'>
            {{version.gitBranch}}
          </span>
        </p>
        <p class='version_infor'>
          <span class='version_title'>
            CommitHash:
          </span>
          <span class='version_content'>
            {{version.gitCommitHash}}
          </span>
        </p>
        <p class='version_infor'>
          <span class='version_title'>
            最后更新:
          </span>
          <span class='version_content'>{{version.gitCommitTimeStamp}}</span>
        </p>
      </div>
      <el-button slot="reference">版本: {{version.weEventVersion}}</el-button>
    </el-popover>
    <router-link to='./servers' v-show='!noServer'>服务设置</router-link>
    <span class='el-icon-user-solid' style='margin-right:5px'></span>
    <el-dropdown trigger="click" @command='selectItem'>
      <span v-if='!userName' @click='loginIn'>请登录</span>
      <span class="el-dropdown-link" v-else-if='userName'>
        {{userName}}<i class="el-icon-arrow-down el-icon-caret-bottom"></i>
      </span>
      <el-dropdown-menu slot="dropdown">
        <el-dropdown-item command='setting'>设置</el-dropdown-item>
        <el-dropdown-item command='loginOut'>退出</el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
  </div>
</div>
</template>
<script>
import API from '../API/resource.js'
export default {
  props: {
    noServer: Boolean
  },
  data () {
    return {
      activeName: 'WeEvent',
      userName: localStorage.getItem('user'),
      server: '',
      servers: [],
      groupList: [],
      version: {
        buildTimeStamp: '',
        gitBranch: '',
        gitCommitHash: '',
        weEventVersion: ''
      }
    }
  },
  mounted () {
    this.getServer()
  },
  methods: {
    home () {
      this.$router.push('./overview')
      this.$store.commit('set_active', '1-1')
      this.$emit('selecChange', '1-1')
    },
    loginIn () {
      this.$router.push('./login')
    },
    selectItem (e) {
      switch (e) {
        case 'setting':
          this.$router.push({ path: './registered', query: { reset: 0 } })
          break
        case 'loginOut':
          API.loginOut('').then(res => {
            if (res.status === 200 && res.data.code === 0) {
              localStorage.removeItem('user')
              localStorage.removeItem('userId')
              localStorage.removeItem('groupId')
              localStorage.removeItem('brokerId')
              this.$router.push('./login')
            }
          })
          break
      }
    },
    selecServers (e) {
      this.server = this.servers[e].name
      this.$store.commit('set_id', this.servers[e].id)
      localStorage.setItem('brokerId', this.servers[e].id)
    },
    selectGroup (e) {
      this.$store.commit('set_groupId', e)
      localStorage.setItem('groupId', e)
    },
    getServer () {
      let brokerId = localStorage.getItem('brokerId')
      let url = '?userId=' + localStorage.getItem('userId')
      let vm = this
      API.getServer(url).then(res => {
        if (res.status === 200) {
          if (res.data.length) {
            vm.servers = [].concat(res.data)
            if (brokerId) {
              res.data.forEach(e => {
                if (e.id === Number(brokerId)) {
                  vm.server = e.name
                  let id = e.id
                  vm.$store.commit('set_id', id)
                  localStorage.setItem('brokerId', id)
                }
              })
            } else {
              vm.server = res.data[0].name
              let id = res.data[0].id
              vm.$store.commit('set_id', id)
              localStorage.setItem('brokerId', id)
            }
            vm.listGroup()
            vm.getVersion()
          } else {
            vm.$message({
              type: 'warning',
              message: '检测到您还未添加任何服务,请先添加相关服务!'
            })
            vm.$router.push('./servers')
          }
        }
      })
    },
    listGroup () {
      API.listGroup('?brokerId=' + localStorage.getItem('brokerId')).then(res => {
        // if groupId is not existed so set it
        // else use existed groupId
        if (!localStorage.getItem('grouId')) {
          this.groupList = [].concat(res.data)
          this.$store.commit('set_groupId', res.data[0])
          localStorage.setItem('groupId', res.data[0])
        }
      })
    },
    getVersion () {
      let url = '?brokerId=' + localStorage.getItem('brokerId')
      API.getVersion(url).then(res => {
        if (res.data.code === 0) {
          this.version = Object.assign({}, res.data.data)
        }
      })
    }
  },
  computed: {
    menu () {
      return this.$store.state.menu
    },
    brokerId () {
      return this.$store.state.brokerId
    },
    groupId () {
      return this.$store.state.groupId
    }
  },
  watch: {
    brokerId (nVal) {
      this.listGroup()
    }
  }
}
</script>
<style scoped>
  img{
    width:155px;
  }
  .user{
    font-size: 14px;
    display: inline-block;
    margin-right:5px;
    cursor: pointer;
  }
</style>
