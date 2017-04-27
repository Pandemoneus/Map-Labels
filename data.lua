data:extend(
{
  {
    type = "train-stop",
    name = "map-label",
    flags = {"player-creation", "filter-directions"},
    max_health = 1,
    collision_mask = {"ghost-layer"},
    animation_ticks_per_frame = 20,
    animations =
    {
      north =
      {
        filename = "__MapLabels__/trans.png",
        priority = "high",
        width = 1,
        height = 1,
        frame_count = 1,
        shift = { 0, 0 }
      },
      east =
      {
        filename = "__MapLabels__/trans.png",
        priority = "high",
        width = 1,
        height = 1,
        frame_count = 1,
        shift = { 0, 0 }
      },
      south =
      {
        filename = "__MapLabels__/trans.png",
        priority = "high",
        width = 1,
        height = 1,
        frame_count = 1,
        shift = { 0, 0 }
      },
      west =
      {
        filename = "__MapLabels__/trans.png",
        priority = "high",
        width = 1,
        height = 1,
        frame_count = 1,
        shift = { 0, 0 }
      }
    },
  }
})
