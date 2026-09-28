<script setup>
const appName = __APP_NAME__
const version = __APP_VERSION__
</script>

<template>
  <main class="page">
    <section class="profile">
      <p class="name">{{ appName }}</p>
      <p class="caption">Versi yang sedang berjalan</p>
      <p class="version" aria-label="Versi aplikasi">v{{ version }}</p>
    </section>
  </main>
</template>

<style scoped>
.page {
  min-height: 100%;
  display: grid;
  place-items: center;
  padding: max(1.5rem, env(safe-area-inset-top)) 1.5rem 1.5rem;
}
.profile {
  width: min(32rem, 100%);
  background: var(--surface);
  border: 1px solid var(--line);
  border-left: 6px solid var(--accent);
  border-radius: 6px;
  padding: 2.5rem 2rem;
}
.name {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
}
.caption {
  margin: 0.25rem 0 1.5rem;
  color: var(--muted);
}
.version {
  margin: 0;
  color: var(--accent);
  font-family: ui-monospace, "SF Mono", Menlo, Consolas, monospace;
  font-size: clamp(2.5rem, 12vw, 4.5rem);
  font-weight: 700;
  letter-spacing: -0.02em;
  overflow-wrap: anywhere;
}
</style>
