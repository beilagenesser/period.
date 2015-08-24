# h.rb
# shameless robbed by samaaron
define :ocean do |num, amp_mul=1|
  with_fx :reverb, mix: 0.5 do
    with_fx(:echo, delay: 0.5, decay: 4) do
      num.times do
        s = synth [:bnoise, :cnoise, :gnoise].choose, amp: rrand(0.5, 1.5) * amp_mul, attack: rrand(0, 4), sustain: rrand(0, 2), release: rrand(0, 5) + 0.5, cutoff_slide: rrand(0, 5), cutoff: rrand(60, 100), pan: rrand(-1, 1), pan_slide: 1, amp: rrand(0.5, 1)
        control s, pan: rrand(-1, 1), cutoff: rrand(60, 110)
        sleep rrand(2, 4)
      end
    end
  end
end

define :echoes do |amp=1|
  with_fx :reverb, room: 0.8,  damp: 0.9 do
    with_fx :distortion, distort:  0.8, amp: 0.5 * amp do
      sample :guit_em9, rate: rrand(0.4,0.8)
      sleep 7.75 + [0.25, 0.5, 0.5, 0.5, 1, 1].choose
    end
  end
end

cue :oceans
at [7, 12], [:crash, :within_oceans] do |m|
  cue m
end
uncomment do
  use_random_seed 0
  with_bpm 45 do
    in_thread(name: :meer) do
      use_random_seed 2
      puts "ocean 1"
      ocean 3, 0.6
      puts "ocean 2"
      ocean 7
      puts "ocean 3"
      ocean 3, 0.75
      puts "ocean 4"
      ocean 2, 0.5
      puts "ocean 5"
      ocean 3, 0.25
      puts "ocean 6"
      ocean 5, 0.17
    end
    sleep 22
    echoes
    cue :a_distant_object
    echoes
    cue :breathes_time
    in_thread do
      echoes
    end
    5.times do
      echoes
    end
    cue :liminality_holds_fast
    echoes
    in_thread do
      8.times do
        synth :prophet, note: :e1, release: 8, cutoff: (line 70, 130, steps: 8).tick
        sleep 8
      end
    end
    4.times do
      echoes
    end
    cue :within_reach
    echoes
    cue :as_it_unfolds
    in_thread do
      echoes
    end
  end
end

puts "done.."