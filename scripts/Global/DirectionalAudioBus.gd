extends Node

@warning_ignore("unused_signal")
signal puerta(izquierda: bool)

@warning_ignore("unused_signal")
signal button(izquierda: bool, on: bool)

@warning_ignore("unused_signal")
signal vhs_act_audio(stat: int)
@warning_ignore("unused_signal")
signal vhs_change_audio_stream(new: AudioStream)

@warning_ignore("unused_signal")
signal encajar_linterna(on: bool)

signal switch(control: String)
