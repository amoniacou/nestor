<template lang="pug">
  div
    v-toolbar(light app dense)
        v-toolbar-title
          h4 Nestor
        v-spacer
        template(v-if="logged")
          v-btn(icon @click.prevent="toggleSidebar" class="toggle-button")
            v-icon menu
          template
            navigation(
              :sm-hide="true"
              :items="rooms")
          v-spacer
          v-btn(flat @click="logout") Logout
        template(v-else)
            .text-nowrap
              template(v-if="$route.path.match('/users/sign_up')")
                | Already have an account?
                | &nbsp;
                router-link(to="/users/sign_in" class='rtr-link') Log in
              template(v-else-if="$route.path.match('/users/sign_in')")
                | New here?
                | &nbsp;
                router-link(to="/users/sign_up" class='rtr-link') Register
              template(v-else)
                v-btn(type='link' @click="login") login
                v-btn(type='link' @click="register") sign up
</template>

<script>
  import Navigation from '../components/Navigation'
  export default {
    components: {
      Navigation
    },
    data: () => ({
      logged: true,
      showSidebar: false,
      rooms: [
        { title: '1'},
        { title: '2'},
        { title: '3'}
      ],
    }),
    methods: {
      toggleSidebar() {
        this.showSidebar = !this.showSidebar
      },
      logout() {
        this.logged = false
      },
      login() {
        this.logged = true
      },
      register() {
        this.logged = true
      }
    }
  };
</script>
<style lang="scss">
    .rtr-link {
        margin-left: 1%;
        text-decoration: none;
        color: green;
    }

    .home-link {
        text-decoration: none;
        color: black;
    }

    .text-nowrap {
        white-space: nowrap;
    }

    .toggle-button {
        position: absolute;
        left: 5px;
        top: 0;
    }
    .sidebar {
        height: 100%;
        padding-top: 15px;
        margin-top: 0px;
        max-height: calc(100% - 0px);
        width: 300px;
        position: fixed;
        top: 0;
        left: 0;
        background: white;
        z-index: 999;
        display: flex;
        flex-direction: column;
        transform: translateX(-300px);
        transition: transform .2s cubic-bezier(.4,0,.2,1);

        &--active {
            transform: translateX(0px);
        }

        &:before {
            content: '';
            position: absolute;
            right: 0;
            top: 0;
            bottom: 0;
            width: 1px;
            background: rgba(0, 0, 0, 0.2);
        }

        .toolbar__items {
            display: flex;
            flex-direction: column;
            align-items: baseline;
            justify-content: flex-start;
            flex-shrink: 0;

            .btn {
                height: auto;
                width:100%;
                padding: 10px 20px;
            }

            .btn__content {
                display: block;
                text-align-last: left;
            }
        }
    }
    .overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        pointer-events: none;
        transition: opacity .5s cubic-bezier(.25,.8,.5,1);
        z-index: 5;

        &:before {
            background-color: #212121;
            bottom: 0;
            content: "";
            height: 100%;
            left: 0;
            opacity: 0;
            right: 0;
            top: 0;
            transition: inherit;
            transition-delay: .15s;
            width: 100%;
            position: absolute
        }

        &--active {
            pointer-events: auto;
            touch-action: none;

            &:before {
                opacity: .46;
            }
        }
    }
    .toggle-button {
        display: block !important;
        position: absolute !important;
        left: 0;
        top: 0;
        @media (min-width: 961px) {
            display: none !important;
        }
    }
</style>
