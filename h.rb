# h.rb

deepdrip =  "/home/hlins/workspace/private/period./samples/deepdrip.wav"
sd_drip = sample_duration deepdrip
cave = "/home/hlins/workspace/private/period./samples/cave.wav"
sd_cave = sample_duration cave


# shamelessly robbed by samaaron
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


in_thread do
  sync :enterthecave
  puts sd_cave
  amp_mul = 5
  cs = sample cave, amp: 0, finish: 0.30
  10.times do
    control cs, amp: amp_mul * (line 0, 1, steps: 10).tick
    sleep 3
  end
  puts "cave at full amp"
  sleep 110
  10.times do
    control cs, amp: amp_mul * (line 1, 0, steps: 10).tick
    sleep 3
  end
  cue :leavingthecave
end

uncomment do
  in_thread(name: :waterdripping)do
    sync :drips
    16.times do
      with_fx :echo, mix: rrand(0.1,0.6), decay: 4, amp: 0.4 do
        sdd = sample deepdrip, amp: rrand(0.1, 0.5), pan: rrand(-1, 1), cutoff: rrand(60, 110), rate: rrand(0.5,1.9)
        sleep sd_drip + [4.2, 3.7, 0, 0, 1, 2.5,5.8].choose
      end
    end
    cue :end_waterdripping
  end
end

in_thread(name: :outro) do
  sync :outro
  oceans_reps = [3  ,  1,   3,  6,   3,  5]
  oceans_amps = [0.6,1.4,0.45,0.3,0.15,0.1]
  i = 0
  6.times do
    ocean oceans_reps[i],oceans_amps[i]
    i = i + 1
  end
end

in_thread(name: :intro_meer) do
  sync :intro
  use_random_seed 2
  oceans_reps = [3  ,7,    3,  2,   3,  5]
  oceans_amps = [0.6,1,0.75,0.5,0.25,0.17]
  i = 0
  6.times do
    ocean oceans_reps[i],oceans_amps[i]
    cue :enterthecave if i == 4
    cue :drips if i ==  5
    i = i + 1
  end
end



uncomment do
  use_random_seed 0
  with_bpm 45 do
    sleep 1
    cue :intro
    sync :enterthecave
    sleep 2
    #TODO make in_thread
    echoes 0.7
    echoes 0.8
    in_thread do
      echoes 0.9
    end
    5.times do
      echoes
    end
    echoes
    in_thread do
      9.times do
        use_synth :prophet
        notes = [:e1,:eb1,:d1,:db1].choose
        tonics = ['augmented',:major,'m',:minor,'m6','m9'].choose
        puts notes
        puts tonics
        play :e1, amp: 0.5, release: 8, cutoff: 120 if one_in(4)
        play chord(notes,tonics), amp: 0.8, release: 8, cutoff: (line 70, 130, steps: 9).tick
        sleep 8
      end
      cue :outro
    end
    4.times do
      echoes
    end
    echoes
    in_thread do
      echoes
    end
  end
end
