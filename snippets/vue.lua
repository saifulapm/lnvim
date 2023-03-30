---@diagnostic disable: undefined-global

return {
  -- Function declaration
  s(
    'f',
    fmt(
      [[
const {} = ({}) => {{
  {}
}};
]],
      { i(1), i(2), i(3) }
    )
  ),

  -- Debugging composables with watchEffect
  s(
    'debug',
    fmt(
      [[
watchEffect(() => {{
  console.log({{ {} }})
}});
]],
      { i(1) }
    )
  ),

  -- Vue component
  s(
    'comp',
    fmt(
      [[
<template>
  <div />
</template>
<script lang="ts">
import {{ defineComponent }} from '@vue/composition-api';
export default defineComponent({{
  setup() {{
    {}
  }},
}});
</script>
<style lang="scss" scoped>
</style>
]],
      { i(1) }
    )
  ),
}
