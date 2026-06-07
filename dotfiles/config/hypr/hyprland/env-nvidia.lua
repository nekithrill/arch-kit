-- Uncomment the source line in hyprland.lua if you have NVIDIA GPU
hl.env({
    GBM_BACKEND = "nvidia-drm",
    __GLX_VENDOR_LIBRARY_NAME = "nvidia",
    LIBVA_DRIVER_NAME = "nvidia",
    WLR_NO_HARDWARE_CURSORS = "1",
})