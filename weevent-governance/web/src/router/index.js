import Vue from 'vue'
import Router from 'vue-router'

import login from '../login/login'
import registered from '../components/registered'
import reset from '../components/reset'
import index from '../module/index'
import topicList from '../components/topicList'
import subcription from '../components/subcription'
// WeBase Module
import overview from '../components/webase/overview'
import group from '../components/webase/group'
import blockInfor from '../components/webase/blockInfor'
import transactionInfor from '../components/webase/transactionInfor'
import servers from '../components/servers'

Vue.use(Router)

export default new Router({
  // mode: 'history',
  routes: [
    {
      path: '/',
      name: 'index',
      component: index,
      children: [{
        path: '/topicList',
        name: 'topicList',
        component: topicList
      }, {
        path: '/subcription',
        name: 'subcription',
        component: subcription
      }, {
        path: '/index',
        name: 'overview',
        component: overview
      }, {
        path: '/group',
        name: 'group',
        component: group
      }, {
        path: '/blockInfor',
        name: 'blockInfor',
        component: blockInfor
      }, {
        path: '/transactionInfor',
        name: 'transactionInfor',
        component: transactionInfor
      }]
    }, {
      path: '/servers',
      name: 'servers',
      component: servers
    }, {
      path: '/login',
      name: 'login',
      component: login
    }, {
      path: '/registered',
      name: 'registered',
      component: registered
    }, {
      path: '/reset',
      name: 'reset',
      component: reset
    }
  ]
})
