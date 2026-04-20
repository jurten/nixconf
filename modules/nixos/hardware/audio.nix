{ ... }: {
  # PipeWire is the modern audio/video routing daemon
  # Replaces PulseAudio and ALSA directly; exposes compatibility layers for both
  services.pulseaudio.enable = false;  # must be off — conflicts with PipeWire
  security.rtkit.enable = true;        # gives PipeWire real-time scheduling priority

  services.pipewire = {
    enable = true;
    alsa.enable = true;           # ALSA compatibility (low-level audio apps)
    alsa.support32Bit = true;     # needed for 32-bit games / Wine audio
    pulse.enable = true;          # PulseAudio compatibility (most desktop apps)
  };
}
