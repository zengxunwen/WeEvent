import Vue from 'vue'
import vuex from 'vuex'
Vue.use(vuex)

export default new vuex.Store({
  state: {
    userName: '',
    goLogin: false,
    active: '',
    menu: '',
    brokerId: '',
    groupId: ''
  },
  mutations: {
    set_name (state, note) {
      state.userName = note
    },
    set_menu (state, menu) {
      state.menu = menu
    },
    set_active (state, active) {
      state.active = active
    },
    back (state, goLogin) {
      state.goLogin = goLogin
    },
    set_id (state, id) {
      state.brokerId = id
    },
    set_groupId (state, id) {
      state.groupId = id
    }
  }
})
