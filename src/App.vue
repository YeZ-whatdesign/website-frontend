<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
/* 暗色模式全局变量 */
:root {
  --bg-primary: #1a1a1a;
  --bg-secondary: #2d2d2d;
  --bg-tertiary: #3a3a3a;
  --text-primary: #ffffff;
  --text-secondary: #b0b0b0;
  --text-muted: #888888;
  --accent-color: #29abc1;
  --accent-hover: #1e8a9e;
  --border-color: #404040;
  --shadow-dark: 0 5px 15px rgba(0, 0, 0, 0.3);
  --card-bg: #2d2d2d;
  --input-bg: #3a3a3a;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  line-height: 1.6;
  color: var(--text-primary);
  background-color: var(--bg-primary);
}

#app {
  min-height: 100vh;
  background-color: var(--bg-primary);
}
</style>