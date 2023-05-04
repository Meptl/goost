extends "res://addons/gut/test.gd"

func test_midi_file():
    var midi = MidiFile.new()
    midi.data = PackedByteArray([20, 180, 173])
    midi.data = PackedByteArray([100])
    assert_true(midi.data.size() > 0)
