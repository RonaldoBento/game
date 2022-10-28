# Title Melodia

#==============================================================================
# +++ MOG - MELODIA (v1.1) +++
#==============================================================================
# By Moghunter
# https://atelierrgss.wordpress.com/
#==============================================================================
# Sistema de música, efeitos visuáis e jogabilidade rápida e simples.
# Este script pode ser usado como minigame avançado ou mesmo como um jogo 
# completo dependendo da utilização do sistema.
#==============================================================================

#==============================================================================
# ● PARA CHAMAR O SCRIPT
#==============================================================================
# Use o comando abaixo através do comando chamar script.
#
# melodia_a(A,B)
#
# A - ID do Stágio
# B - ID da Switch que será ativada ao vencer o stágio. (Opcional)
#
#==============================================================================

#==============================================================================
# ● OUTRAS INFORMAÇÕES
#==============================================================================
# 1 - O record de pontos ficará gravado na variável ID 101 (Default).
# 2 - A quantidade de combos maximo ficará gravado na variável ID 102(Default).
# 3 - As imagem devem ser gravádas na pasta 
#     Graphics/Melodia/
#==============================================================================

#==============================================================================
# ● HISTÓRICO
#==============================================================================
# 1.1 - Corrigido o bug da função Pause ao terminar o Stagio.
#==============================================================================

#==============================================================================
# ■ STAGE SETUP
#==============================================================================
module MOG_MELODIA_STAGE_SETUP
  
    # ☢CAUTION!!☢ Pleae, don't Touch.^_^
    STAGE_BASE_SETUP = []
    STAGE_MUSIC = []
    STAGE_BACKGROUND = []
    STAGE_CHARACTER = []
    STAGE_PARTICLES = []
    # ☢CAUTION!!☢ Pleae, don't Touch.^_^
    
    #--------------------------------------------------------------------------  
    # ● SYSTEM_SETUP
    #--------------------------------------------------------------------------
    # STAGE_SYSTEM_SETUP[ID] = [A,B,C,D]
    #
    # ID    =  STAGE ID
    #          ID do stagio.
    # A     =  PLAYER HP
    #          Quantidade de vezes que você pode errar durante um stagio.
    # B     =  APPEAL METER
    #          Quantidade de vezes que você deve acertar para vencer o stagio.
    # C     =  STAGE DURATION (In Sec / 60 = 1 min)
    #          Tempo limite para vencer o stagio. 
    # D     =  REACTION SPEED (60 = 1 Sec)
    #          Tempo limite para pressionar o botão certo.  
    #--------------------------------------------------------------------------
    STAGE_BASE_SETUP[1] = [10,20,180,60]
    STAGE_BASE_SETUP[2] = [10,30,180,60]
    STAGE_BASE_SETUP[3] = [10,40,180,60]
    STAGE_BASE_SETUP[4] = [10,50,180,60]
    STAGE_BASE_SETUP[5] = [10,60,180,60]
    
    
    #--------------------------------------------------------------------------  
    # ● MUSIC SETUP
    #--------------------------------------------------------------------------
    # STAGE_MUSIC[ID] = ["A","A","A"...] 
    #
    #  ID   = STAGE ID
    #
    #  A    = Definição do nome do arquivo de música.(Pode ser mais de uma)
    #
    # EG -  STAGE_MUSIC[1] = ["Music_0","Music_1","Music_2"]
    #
    #--------------------------------------------------------------------------
    STAGE_MUSIC[1] = ["1-03 Buy! Buy! Buy!"]
    STAGE_MUSIC[2] = ["Dungeon7"]
    STAGE_MUSIC[3] = ["Battle5"]
    STAGE_MUSIC[4] = ["Battle6"]
    STAGE_MUSIC[5] = ["YuruYuri"]
    
    
    #--------------------------------------------------------------------------  
    # ● STAGE BACKGROUND 1
    #--------------------------------------------------------------------------
    # STAGE_BACKGROUND[ID] = ["A",B,C,D,"E"]
    #
    # ID     = STAGE ID
    #
    # A      = BACKGROUND NAME (File Name)
    #
    # B      = EFFECT TYPE
    #        - 0 = Slide Effect
    #        - 1 = Wave Effect
    #
    # C      = POWER A
    #          Velocidade de deslize na horizontal (Slide Effect)
    #          Area de distorção no efeito WAVE. (de 0 a 9)
    #
    # D      = POWER B
    #          Velocidade de deslize na vertical (Slide Effect)
    #          Velocidade de distorção do efeito WAVE. (de 0 a 9)
    #
    # E      = SECOND BACKGROUND (CHARACTER)
    #
    #--------------------------------------------------------------------------
     STAGE_BACKGROUND[1] = ["Back_01",0,1,0]
     STAGE_BACKGROUND[2] = ["Back_01",0,1,0]
     STAGE_BACKGROUND[3] = ["Back_01",0,1,0]
     STAGE_BACKGROUND[4] = ["Back_01",0,1,0]
     STAGE_BACKGROUND[5] = ["Back_01",0,1,0]
    
    #--------------------------------------------------------------------------  
    # ● STAGE CHARACTER
    #--------------------------------------------------------------------------
    # STAGE_CHARACTER[A] = ["B",C]
    #
    # A - STAGE ID
    # B - BREATH EFFECT 
    #     Ativar o efeito de respiração 
    #--------------------------------------------------------------------------
    STAGE_CHARACTER[1] = ["Char_01",false]
    STAGE_CHARACTER[2] = ["Char_02",false]
    STAGE_CHARACTER[3] = ["Char_03",false]
    STAGE_CHARACTER[4] = ["Char_04",false]
    STAGE_CHARACTER[5] = ["Char_05",false]
    
   
    #--------------------------------------------------------------------------  
    # ● STAGE PARTICLES
    #--------------------------------------------------------------------------  
    # STAGE_PARTICLES[ID] = ["A", B, C, D, E , F, G]
    #
    # ID     = STAGE ID
    #
    # B      = X SPEED
    #          Velocidade da partícula na horizontal.
    #
    # C      = Y SPEED
    #          Velocidade da partícula na vertical.
    #
    # D      = ANGLE SPEED
    #          Velocidade do angûlo na partícula.
    #
    # E      = BLENDY TYPE
    #          Tipo do Efeito Blendy.
    #
    # F      = RANDOM COLOR
    #          Ativar Cores aleatórias.
    #
    # G      = NUMBER OF PARTICLES
    #          Número de partículas. (Tenha o bom senso ao definir quantidade de
    #                                 patículas para não causar lag.)
    #--------------------------------------------------------------------------  
    STAGE_PARTICLES[1] = ["Particle_01",2,0,4,0,true,10]
    STAGE_PARTICLES[2] = ["Particle_02",2,0,4,0,true,10]
    STAGE_PARTICLES[3] = ["Particle_03",2,0,4,0,true,10]  
    STAGE_PARTICLES[4] = ["Particle_04",2,0,4,0,true,10] 
    STAGE_PARTICLES[5] = ["Particle_05",2,0,4,0,true,10] 
    
    
  end  
  
  #==============================================================================
  # ■ GENERAL SETUP
  #==============================================================================
  module MOG_MELODIA_A  
    # Definição da ID variável que ficará gravada o record de pontos.
    STORE_SCORE_VARIABLE_ID = 101
    # Definição da ID variável que ficará gravada o record de combos.
    STORE_COMBO_VARIABLE_ID = 102  
    # Posição do medidor de appeal (Encanto / Charme)
    APPEAL_METER_POS = [81,277]
    # Velocidade de animação do medidor. 
    METER_FLOW_SPEED = 5  
    # Posição do numero do tempo.
    TIME_NUMBER_POS = [100,380]
    # Posição do numero de pontos.
    SCORE_POS = [360, 385]
    # Posição da imagem do fogo. 
    FIRE_POS = [15,235]
    # Velocidade da animação da imagem do fogo.
    FIRE_ANIMATION_SPEED = 3  
    # Posição do medidor de performance.
    PERFORM_POS = [100,15]
    # Posição do medidor de reação.
    REACTION_POS = [315,15]
    # Posição da imagem do botão de pressionar.
    KEY_POS = [155,265]
    # Posição do medidor de stamina.
    STAMINA_METER_POS = [137,340]
    # Posição do numero de combo.
    CB_NUMBER_POS = [453,350]
  end
  
  #===============================================================================
  # ■ MODULE SOUND EFFECTS
  #===============================================================================
  module MOG_MELODIA_A_SOUND_EFFECTS
    #Som do cursor. 
    CURSOR_SE = "Decision1"
    #Som ao pausar o jogo.
    PAUSE_SE = "Chime2"
    #Som ao acertar o comando.
    RIGHT_SE = "Wind7"
    #Definição do volume do som de acerto.
    #(Para aqueles que se incomodam com o som atrapalhando a música de fundo.)
    RIGHT_SE_VOLUME = 70
    #Som ao errar o comando.
    WRONG_SE = "Buzzer1"
    #Som do ultimo acerto de comando.
    LAST_PRESS_SE = "Chime2"
    #Som da tela de resultado.
    RESULT_SE = "Item1"
    #Som do medidor de reação ao chegar a zero.
    REACTION_TIMEOVER_SE = "Load"
    #Som quando a stamina chegar a zero.
    STAMINA_ZERO_SE = "Absorb1"
    #Som do tempo limíte.
    TIMEOVER_SE = "Phone"
  end
  
  
  
  
  #==============================================================================
  # ■ Game System
  #==============================================================================
  class Game_System
    attr_accessor :melodia_a
    attr_accessor :melodia_a_record
    
    #--------------------------------------------------------------------------
    # ● Initialize
    #--------------------------------------------------------------------------  
    alias mog_melodia_a_initialize initialize
    def initialize
        @melodia_a = []
        @melodia_a_record = [0,0]
        mog_melodia_a_initialize
    end  
  
  end
  
  #==============================================================================
  # ■ Game Interpreter
  #==============================================================================
  class Game_Interpreter
    include MOG_MELODIA_STAGE_SETUP
    
    #--------------------------------------------------------------------------
    # ● Melodia
    #--------------------------------------------------------------------------      
    def melodia(stage_id = 1,swith_id = nil) 
        $game_system.melodia_a.clear
        system_setup = STAGE_BASE_SETUP[stage_id] rescue nil
        music_setup = STAGE_MUSIC[stage_id] rescue nil
        background_setup = STAGE_BACKGROUND[stage_id] rescue nil
        character_setup = STAGE_CHARACTER[stage_id] rescue nil
        particles_setup = STAGE_PARTICLES[stage_id] rescue nil
        $game_system.melodia_a[0] = system_setup
        $game_system.melodia_a[1] = music_setup
        $game_system.melodia_a[2] = background_setup
        $game_system.melodia_a[3] = character_setup
        $game_system.melodia_a[4] = particles_setup
        $game_system.melodia_a[5] = swith_id
        SceneManager.call(Scene_Melodia_A)
    end  
    
  end
  
  #==============================================================================
  # ■ Cache
  #==============================================================================
  module Cache
    
    #--------------------------------------------------------------------------
    # ● Moe
    #--------------------------------------------------------------------------
    def self.moe_1(filename)
        load_bitmap("Graphics/Melodia/", filename)
    end
    
  end
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
    include MOG_MELODIA_A
    include MOG_MELODIA_STAGE_SETUP
    
   #------------------------------------------------------------------------------
   # ● Main
   #------------------------------------------------------------------------------     
   def main    
       setup
       create_sprites
       execute_loop
       execute_dispose
   end
    
   #------------------------------------------------------------------------------
   # ● Execute Loop
   #------------------------------------------------------------------------------     
   def execute_loop
       Graphics.transition(60)
       loop do
            Graphics.update
            Input.update
            update
            break if SceneManager.scene != self
       end
   end
  
    #--------------------------------------------------------------------------
    # ● Initialize
    #--------------------------------------------------------------------------      
    def initialize
        BattleManager.save_bgm_and_bgs
        setup_base
        setup_music
    end  
  
    #--------------------------------------------------------------------------
    # ● Setup Music
    #--------------------------------------------------------------------------        
    def setup_music
        music_list = $game_system.melodia_a[1] rescue nil
        @music_name = nil
        return if music_list == nil
        @music_name = music_list[rand(music_list.size)] rescue nil      
    end  
    
    #--------------------------------------------------------------------------
    # ● Setup
    #--------------------------------------------------------------------------        
    def setup
        execute_dispose
        @score = 0
        @score_old = @score
        @score_cache = @score
        @hits = 0
        @event_time = 240
        @event_speed = 1
        @pause = true
        @force_pause = false
        @phase = 0
        @press_refresh = false
        @target_attack_duration = 0
        @hp_number_animation_duration = 0
        @particles_enable = true 
        @particles_max = $game_system.melodia_a[4][6] rescue nil
        @particles_max = 10 if @particles_max == nil
        @misses = 0
        @max_combo = 0
        @max_score = 0
        @top_score = $game_system.melodia_a_record[0]
        @n_hits = 0
        @rank_point = 0
        @rank = "F"
        setup_timer_meter    
    end  
    
    #--------------------------------------------------------------------------
    # ● Setup Base
    #--------------------------------------------------------------------------      
    def setup_base
        if $game_system.melodia_a[0] != nil
           hp = $game_system.melodia_a[0][0]
           appeal_meter = $game_system.melodia_a[0][1]
           stage_duration = $game_system.melodia_a[0][2]
           reation_speed = $game_system.melodia_a[0][3]
        end 
        hp = 10 if hp == nil or hp <= 0
        appeal_meter = 30 if appeal_meter == nil or appeal_meter <= 0
        stage_duration = 1 if stage_duration == nil or stage_duration < 1
        stage_duration = 5999 if stage_duration >= 6000
        reation_speed = 60 if reation_speed == nil or reation_speed <= 0                  
        @player_maxhp = hp
        @player_hp = @player_maxhp    
        @target_maxhp = appeal_meter
        @target_hp = 0
        @stage_duration = stage_duration
        @bonus_speed = 35
        @reaction_time_max = reation_speed
        @reaction_time = @reaction_time_max
        @reaction_time_score = 0
        @reaction_time_average = 0
    end    
    
    #--------------------------------------------------------------------------
    # ● Execute Music
    #--------------------------------------------------------------------------      
    def execute_music
        return if @music_name == nil
        Audio.bgm_play("Audio/BGM/" + @music_name.to_s, 100, 100) rescue nil      
    end  
    
    #--------------------------------------------------------------------------
    # ● Setup Timer
    #--------------------------------------------------------------------------    
    def setup_timer_meter
        @key = 0
        @wait = 0
        @wait_cancel = false
        @timer = 60 * @stage_duration
        @max_time = @timer
        update_timer
        create_meter
        create_number
        create_fire    
    end   
    
    #--------------------------------------------------------------------------
    # ● Start
    #--------------------------------------------------------------------------    
    def create_sprites
        execute_music  
        create_info("Info0")
        create_score
        create_stamina_meter
        create_background_1
        create_background_2
        create_bonus_meter
        create_press
        create_combo
        create_reaction_meter
        create_layout
        create_particles
        create_flash
    end
      
  end
  
  #===============================================================================
  # ■ MELODIA A SOUND EFFECTS
  #===============================================================================
  module MELODIA_A_SOUND_EFFECTS
    include MOG_MELODIA_A_SOUND_EFFECTS
    
    #--------------------------------------------------------------------------
    # ● Play Sound
    #--------------------------------------------------------------------------            
    def play_sound(file_name,volume = 100)
        Audio.se_play("Audio/SE/" + file_name.to_s, volume, 100) rescue nil
    end  
    
    #--------------------------------------------------------------------------
    # ● SE Cursor
    #--------------------------------------------------------------------------          
    def se_cursor
        play_sound(CURSOR_SE)
    end
     
    #--------------------------------------------------------------------------
    # ● SE Wrong
    #--------------------------------------------------------------------------        
    def se_wrong
        play_sound(WRONG_SE)
    end
   
    #--------------------------------------------------------------------------
    # ● SE Right
    #--------------------------------------------------------------------------          
    def se_right
        play_sound(RIGHT_SE, RIGHT_SE_VOLUME)
    end
      
    #--------------------------------------------------------------------------
    # ● SE Pause
    #--------------------------------------------------------------------------          
    def se_pause
        play_sound(PAUSE_SE)
    end
        
    #--------------------------------------------------------------------------
    # ● SE Last Blow
    #--------------------------------------------------------------------------              
    def se_last_blow
        play_sound(LAST_PRESS_SE)
    end
      
    #--------------------------------------------------------------------------
    # ● SE RESULT
    #--------------------------------------------------------------------------              
    def se_result
        play_sound(RESULT_SE)
    end  
    
    #--------------------------------------------------------------------------
    # ● SE REACTION TIMEOVER
    #--------------------------------------------------------------------------              
    def se_reaction_timeover
        play_sound(REACTION_TIMEOVER_SE)
    end 
      
    #--------------------------------------------------------------------------
    # ● SE Stamina Zero
    #--------------------------------------------------------------------------              
    def se_statmina_zero
        play_sound(STAMINA_ZERO_SE)
    end   
  
    #--------------------------------------------------------------------------
    # ● SE TimeOver
    #--------------------------------------------------------------------------              
    def se_timeover
        play_sound(TIMEOVER_SE)
    end     
    
  end
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
        include MELODIA_A_SOUND_EFFECTS
  end
      
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
    
    #--------------------------------------------------------------------------
    # ● Create Flash
    #--------------------------------------------------------------------------  
    def create_flash
        dispose_flash
        @viewport_flash = Viewport.new(0, 105, 544, 170)
        @viewport_flash.z = 1000
        @flash_bitmap =[]
        index = 0
        for i in 0...8
            x = (37 * index) + (KEY_POS[0] - 18)
            @flash_bitmap.push(Flash_Sprite_Melodia_A.new(@viewport_flash,x,index))
            index += 1
        end  
    end  
      
    #--------------------------------------------------------------------------
    # ● Create Particles
    #--------------------------------------------------------------------------  
    def create_particles
        dispose_particles
        return if !@particles_enable
        @viewport_light = Viewport.new(-32, -32, 576, 350)
        @viewport_light.z = 10
        @light_bitmap =[]
        for i in 0...@particles_max
            @light_bitmap.push(Particles_Melodia_A.new(@viewport_light))
        end  
    end
    
    #--------------------------------------------------------------------------
    # ● Create Background 1
    #--------------------------------------------------------------------------        
    def create_background_1
        if $game_system.melodia_a[2] != nil
           file_name = $game_system.melodia_a[2][0] rescue nil
           @back_effect_type = $game_system.melodia_a[2][1] rescue nil
           @back_effect_power_1 = $game_system.melodia_a[2][2] rescue nil
           @back_effect_power_2 = $game_system.melodia_a[2][3] rescue nil
        end  
        file_name = "" if file_name == nil
        @back_effect_type = 0 if @back_effect_type == nil
        @back_effect_power_1 = 1 if  @back_effect_power_1 == nil
        @back_effect_power_2 = 0 if  @back_effect_power_2 == nil  
        @battleback1_bitmap = Cache.moe_1(file_name.to_s) rescue nil
        @battleback1_bitmap = Bitmap.new(32,32) if @battleback1_bitmap == nil
        if @back_effect_type == 0
           @background = Plane.new
           @background.bitmap = @battleback1_bitmap
        else   
           @background = Sprite.new
           range = (@back_effect_power_1 + 1) * 10
           range = 500 if range > 500
           speed = (@back_effect_power_2 + 1) * 100
           speed = 1000 if speed > 1000
           @background.x = -range
           @background.wave_amp = range
           @background.wave_length = 544
           @background.wave_speed = speed        
           @background.bitmap = Bitmap.new(544 + (range * 2),416)
           @background.bitmap.stretch_blt(@background.bitmap.rect, @battleback1_bitmap, @battleback1_bitmap.rect) 
  #         @background.ox = @background.bitmap.width / 2
  #         @background.oy = @background.bitmap.height / 2
  #         @background.x = @background.ox
  #         @background.y = @background.oy          
        end  
  #      @background.bitmap = @battleback1_bitmap
        @background.z = 0
    end
      
      
    #--------------------------------------------------------------------------
    # ● Create Background 2
    #--------------------------------------------------------------------------        
    def create_background_2
        @breach_effect = [1.0,0]
        if $game_system.melodia_a[3] != nil
           file_name = $game_system.melodia_a[3][0] rescue nil
           @breath_effect = $game_system.melodia_a[3][1] rescue nil
        end  
        file_name = "" if file_name == nil
        @breath_effect = false if @breath_effect == nil
        @battleback2_bitmap = Cache.moe_1(file_name.to_s) rescue nil
        @battleback2_bitmap = Bitmap.new(32,32) if @battleback2_bitmap == nil
        @background_2 = Sprite.new
        @background_2.bitmap = @battleback2_bitmap
        @background_2.y = @background_2.bitmap.height
        @background_2.oy = @background_2.bitmap.height      
        @background_2.z = 1
    end
    
    #--------------------------------------------------------------------------
    # ● Create Layout
    #--------------------------------------------------------------------------        
    def create_layout
        @layout = Sprite.new
        @layout.bitmap = Cache.moe_1("Layout")     
        @layout.z = 100     
        @layout.visible = false
    end
    
    #--------------------------------------------------------------------------
    # ● create_meter
    #--------------------------------------------------------------------------  
    def create_meter
        @meter_flow = 0
        @meter_image = Cache.moe_1("Timer_Meter")
        @meter_bitmap = Bitmap.new(@meter_image.width,@meter_image.height)
        @meter_range = @meter_image.width / 3
        @meter_width = @meter_range * @target_hp / @target_maxhp
        @meter_height = @meter_image.height / 2
        @meter_sprite = Sprite.new
        @meter_sprite.bitmap = @meter_bitmap
        @meter_sprite.z = 201
        @meter_sprite.x = APPEAL_METER_POS[0]
        @meter_sprite.y = APPEAL_METER_POS[1]
        @meter2_width = @meter_range
        @meter2_bitmap = Bitmap.new(@meter_image.width,@meter_image.height)      
        @meter2_sprite = Sprite.new
        @meter2_sprite.bitmap = @meter2_bitmap
        @meter2_sprite.z = 200
        @meter2_sprite.mirror = true      
        @meter2_sprite.x =  APPEAL_METER_POS[0] - (@meter_range * 2)
        @meter2_sprite.y =  APPEAL_METER_POS[1] 
        @meter_sprite.bitmap.clear
        @meter2_sprite.bitmap.clear      
        @meter_width = @meter_range * @target_hp / @target_maxhp
        @meter_src_rect = Rect.new(@meter_flow, 0,@meter_width, @meter_height)
        @meter_bitmap.blt(0,0, @meter_image, @meter_src_rect)          
        @meter2_src_rect = Rect.new(@meter_flow, @meter_height,@meter2_width, @meter_height)
        @meter2_bitmap.blt(0,0, @meter_image, @meter2_src_rect)          
        @meter_flow += METER_FLOW_SPEED  
        @meter_flow = 0 if @meter_flow >= @meter_image.width - @meter_range     
        @meter_sprite.visible = false
        @meter2_sprite.visible = false
    end  
    
    #--------------------------------------------------------------------------
    # ● Create Bonus Meter
    #--------------------------------------------------------------------------  
    def create_bonus_meter
        @perform = 0
        @perform_max = 1000
        @p_image = Cache.moe_1("P_Meter")
        @p_bitmap = Bitmap.new(@p_image.width,@p_image.height)
        @p_width = @p_image.width * @perform / @perform_max
        @p_height = @p_image.height
        @p_src_rect = Rect.new(0, 0, @p_width, @p_height)
        @p_bitmap.blt(0,0, @p_image, @p_src_rect) 
        @p_sprite = Sprite.new
        @p_sprite.bitmap = @p_bitmap
        @p_sprite.z = 201
        @p_sprite.x = PERFORM_POS[0]
        @p_sprite.y = PERFORM_POS[1]
        @p_sprite.visible = false
        update_bonus_meter
    end    
    
    #--------------------------------------------------------------------------
    # ● Create Reaction Meter
    #--------------------------------------------------------------------------    
    def create_reaction_meter
        @r_image = Cache.moe_1("Reaction_Meter")
        @r_bitmap = Bitmap.new(@r_image.width,@r_image.height)
        @r_width = @r_image.width * @reaction_time / @reaction_time_max
        @r_height = @r_image.height
        @r_sprite = Sprite.new
        @r_sprite.bitmap = @r_bitmap
        @r_sprite.z = 201
        @r_sprite.x = REACTION_POS[0]
        @r_sprite.y = REACTION_POS[1]
        @r_sprite.visible = false
        update_reaction_meter 
    end
    
    #--------------------------------------------------------------------------
    # ● create press
    #--------------------------------------------------------------------------    
    def create_press
        @next_key = 0
        @pressed_key = 0
        @press_image = Cache.moe_1("Button")
        @press_bitmap = Bitmap.new(@press_image.width,@press_image.height)
        @press_width = @press_image.width / 9
        @press_height = @press_image.height
        make_next_command
        @press_src_rect = Rect.new(@next_key * @press_width, 0, @press_width, @press_height)
        @press_bitmap.blt(0,0, @press_image, @press_src_rect) 
        @press_sprite = Sprite.new
        @press_sprite.bitmap = @press_bitmap
        @press_sprite.z = 201
        @press_sprite.x = KEY_POS[0]
        @press_sprite.y = KEY_POS[1]  
        @press_sprite.ox = @press_width / 2
        @press_sprite.oy = @press_height
        @press_sprite.visible = false
    end
    
    #--------------------------------------------------------------------------
    # ● Check Key Position
    #--------------------------------------------------------------------------      
    def check_key_position
        @key_pos = (@next_key * @press_width) + KEY_POS[0]
        @press_sprite.x = @key_pos 
    end  
    
    #--------------------------------------------------------------------------
    # ● create_number
    #--------------------------------------------------------------------------  
    def create_number
        @number_image = Cache.moe_1("Timer_Number")
        @number_bitmap = Bitmap.new(@number_image.width,@number_image.height)
        @number_sprite = Sprite.new
        @number_sprite.bitmap = @number_bitmap
        @number_sprite.z = 203
        @number_sprite.x = TIME_NUMBER_POS[0]
        @number_sprite.y = TIME_NUMBER_POS[1]
        @number_cw = @number_image.width / 10
        @number_ch = @number_image.height    
        refresh_number
        @number = @total_sec
        @number_sprite.visible = false
    end 
      
    #--------------------------------------------------------------------------
    # ● Create Stamina Meter
    #--------------------------------------------------------------------------    
    def create_stamina_meter
        @old_stamina = -1
        @hp2_image = Cache.moe_1("Stamina_Meter")
        @hp2_bitmap = Bitmap.new(@hp2_image.width,@hp2_image.height)
        @hp2_width = @hp2_image.width * @player_hp / @player_maxhp
        @hp2_height = @hp2_image.height
        @hp2_sprite = Sprite.new
        @hp2_sprite.bitmap = @hp2_bitmap
        @hp2_sprite.z = 201
        @hp2_sprite.x = STAMINA_METER_POS[0]
        @hp2_sprite.y = STAMINA_METER_POS[1]
        @hp2_sprite.visible = false
        refresh_stamina_meter             
    end  
      
    #--------------------------------------------------------------------------
    # ● Create Combo
    #--------------------------------------------------------------------------     
    def create_combo
        @combo = 0
        @combo_old = @combo
        @cb_number_image = Cache.moe_1("CB_Number")
        @cb_number_bitmap = Bitmap.new(@cb_number_image.width,@cb_number_image.height)
        @cb_number_sprite = Sprite.new
        @cb_number_sprite.bitmap = @cb_number_bitmap
        @cb_number_sprite.z = 203
        @cb_number_sprite.x = CB_NUMBER_POS[0]
        @cb_number_sprite.y = CB_NUMBER_POS[1]
        @cb_number_cw = @cb_number_image.width / 10
        @cb_number_ch = @cb_number_image.height
        @cb_number_sprite.ox = @cb_number_cw /2
        @cb_number_sprite.oy = @cb_number_ch / 2
        @cb_number_sprite.visible = false
        @combo_animation_duration = 0
        refresh_cb_number   
    end  
    
    #--------------------------------------------------------------------------
    # ● create_score
    #--------------------------------------------------------------------------  
    def create_score
        @score_image = Cache.moe_1("Number_Score")
        @score_bitmap = Bitmap.new(@score_image.width,@score_image.height)
        @score_sprite = Sprite.new
        @score_sprite.bitmap = @score_bitmap
        @score_sprite.z = 203
        @score_sprite.x = SCORE_POS[0]
        @score_sprite.y = SCORE_POS[1]
        @score_cw = @score_image.width / 10
        @score_ch = @score_image.height    
        refresh_score
        @score_sprite.visible = false
    end   
    
    #--------------------------------------------------------------------------
    # ● create_fire
    #--------------------------------------------------------------------------  
    def create_fire
        @fire_flow = 0
        @fire_flow_speed = 0
        @fire_refresh = false
        @fire_image = Cache.moe_1("Timer_Fire")
        @fire_bitmap = Bitmap.new(@fire_image.width,@fire_image.height)
        @fire_width = @fire_image.width / 4    
        @fire_src_rect_back = Rect.new(0, 0,@fire_width, @fire_image.height)
        @fire_bitmap.blt(0,0, @fire_image, @fire_src_rect_back)    
        @fire_sprite = Sprite.new
        @fire_sprite.bitmap = @fire_bitmap
        @fire_sprite.z = 99
        @fire_sprite.x = FIRE_POS[0]
        @fire_sprite.y = FIRE_POS[1]
        @fire_sprite.visible = false
        update_fire 
    end  
      
    #--------------------------------------------------------------------------
    # ● Create Info
    #--------------------------------------------------------------------------        
    def create_info(file_name)
        dispose_info
        @info = Plane.new
        @info.bitmap = Cache.moe_1(file_name) rescue nil
        @info.bitmap = Cache.moe_1("") if @info.bitmap == nil
        @info.z = 999
        @info.opacity = 255
    end   
    
    #--------------------------------------------------------------------------
    # ● Create Result Text
    #--------------------------------------------------------------------------          
    def create_result_text
        @result_sprite = Sprite.new
        @result_sprite.bitmap = Bitmap.new(544,416)
        @result_sprite.bitmap.font.size = 38
        @result_sprite.bitmap.font.bold = true
        #Reaction Result
        @result_sprite.bitmap.draw_text(215,0,320,40,@reaction_time_average.to_s,2) 
        #Max Combo
        @result_sprite.bitmap.draw_text(215,39,320,40,@max_combo.to_s,2)
        #Miss
        @result_sprite.bitmap.draw_text(215,79,320,40,@misses.to_s,2)
        #Score
        @result_sprite.bitmap.draw_text(215,168,320,40,@max_score.to_s,2)      
        #RANK
        @result_sprite.bitmap.font.size = 96
        @result_sprite.bitmap.font.italic = true
        @result_sprite.bitmap.font.color = Color.new(255,155,100)
        @result_sprite.bitmap.draw_text(115,200,320,100,@rank.to_s,2)      
        @result_sprite.ox = @result_sprite.bitmap.width / 2
        @result_sprite.oy = @result_sprite.bitmap.height / 2
        @result_sprite.x = @result_sprite.bitmap.width / 2
        @result_sprite.y = @result_sprite.bitmap.width / 2
        @result_sprite.z = 999
    end   
    
    #--------------------------------------------------------------------------
    # ● Objects Sprites Visible
    #--------------------------------------------------------------------------              
    def objects_sprites_visible(valor = true)
        @press_sprite.visible = valor
        @layout.visible = valor
        @meter_sprite.visible = valor
        @meter2_sprite.visible = valor
        @p_sprite.visible = valor
        @r_sprite.visible = valor
        @number_sprite.visible = valor
        @hp2_sprite.visible = valor
        @cb_number_sprite.visible = valor
        @score_sprite.visible = valor
        @fire_sprite.visible = valor  
    end  
    
  end
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Particles_Melodia_A < Sprite
    
   #--------------------------------------------------------------------------
   # ● Initialize
   #--------------------------------------------------------------------------             
    def initialize(viewport = nil)
        super(viewport)
        if  $game_system.melodia_a[4] != nil
            file_name =  $game_system.melodia_a[4][0] rescue nil
            @speed_x = $game_system.melodia_a[4][1]
            @speed_y = $game_system.melodia_a[4][2]
            @speed_a = $game_system.melodia_a[4][3]
            blendy = $game_system.melodia_a[4][4]
            random_color = $game_system.melodia_a[4][5]
        end                
        @speed_x = 0 if @speed_x == nil
        @speed_y = 0 if @speed_y == nil
        @speed_a = 0 if @speed_a == nil
        blendy = 1 if blendy == nil
        random_color = false if random_color == nil
        self.bitmap = Cache.moe_1(file_name.to_s) rescue nil
        self.bitmap = Cache.moe_1("") if self.bitmap == nil      
        self.tone.set(rand(255),rand(255), rand(255), 255) if random_color
        self.blend_type = blendy
        reset_setting
    end  
    
   #--------------------------------------------------------------------------
   # ● Reset Setting
   #--------------------------------------------------------------------------               
    def reset_setting
        zoom = (50 + rand(100)) / 100.1
        self.zoom_x = zoom
        self.zoom_y = zoom
        self.x = rand(576) -32
        self.y = rand(320 + self.bitmap.height)
        self.opacity = 0
        self.angle = rand(360)
    end
    
   #--------------------------------------------------------------------------
   # ● Dispose
   #--------------------------------------------------------------------------               
    def dispose
        super
        self.bitmap.dispose if self.bitmap != nil
    end  
    
   #--------------------------------------------------------------------------
   # ● Update
   #--------------------------------------------------------------------------               
    def update
        super
        self.x += @speed_x
        self.y -= @speed_y
        self.angle += @speed_a      
        self.opacity += 5
        reset_setting if can_reset_setting?
    end  
    
   #--------------------------------------------------------------------------
   # ● Can Reset Setting
   #--------------------------------------------------------------------------                 
    def can_reset_setting?
        return true if !self.x.between?(-32,580)
        return true if !self.y.between?(-32,370)
        return false
    end  
  end
  
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Flash_Sprite_Melodia_A < Sprite
    
   #--------------------------------------------------------------------------
   # ● Viewport
   #--------------------------------------------------------------------------                 
    def initialize(viewport,x,index)
        super(viewport)
        self.bitmap = Cache.moe_1("Flash_Effect")
        self.x = x
        self.y = 0
        self.opacity = 0
        self.visible = false
        self.blend_type = 1
        set_color(index)
    end
    
   #--------------------------------------------------------------------------
   # ● Set Color
   #--------------------------------------------------------------------------                 
    def set_color(index)
        case index
           when 0;  self.tone.set(0,0,255, 255)
           when 1;  self.tone.set(0,255,0, 255)
           when 2;  self.tone.set(255,0,0, 255)
           when 3;  self.tone.set(125,125,125, 255)  
           when 4;  self.tone.set(0,255,255, 255)              
           when 5;  self.tone.set(255,255,0, 255)                  
           when 6;  self.tone.set(255,0,255, 255)     
           when 7;  self.tone.set(55,255,125, 255)       
        end    
    end  
    
   #--------------------------------------------------------------------------
   # ● Dispose
   #--------------------------------------------------------------------------               
    def dispose
        super
        self.bitmap.dispose
    end  
   
   #--------------------------------------------------------------------------
   # ● Update
   #--------------------------------------------------------------------------                   
    def update
        super    
        update_effect
    end  
    
   #--------------------------------------------------------------------------
   # ● Update Effect
   #--------------------------------------------------------------------------                     
    def update_effect
        self.opacity -= 5
        self.visible = false if self.opacity == 0
    end  
    
   #--------------------------------------------------------------------------
   # ● Flash Effect
   #--------------------------------------------------------------------------                     
    def flash_effect
        @effect_duration = 0
        self.visible = true
        self.opacity = 255
        self.y = 0
    end  
    
  end
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
    
    #--------------------------------------------------------------------------
    # ● Execute Dispose
    #--------------------------------------------------------------------------
    def execute_dispose
        Graphics.freeze
        dispose_target_meter
        dispose_combo_number
        dispose_time_number
        dispose_background
        dispose_fire_animation
        dispose_layout
        dispose_score
        dispose_perform_meter
        dispose_reaction_meter
        dispose_hp_meter
        dispose_button
        dispose_info
        dispose_particles
        dispose_flash
        dispose_result_text
        BattleManager.replay_bgm_and_bgs
    end
    
    #--------------------------------------------------------------------------
    # ● Dispose Result Text
    #--------------------------------------------------------------------------          
    def dispose_result_text
        return if @result_sprite == nil 
        @result_sprite.bitmap.dispose
        @result_sprite.dispose   
        @result_sprite = nil
    end  
   
   #--------------------------------------------------------------------------
   # ● Dispose Target Meter
   #--------------------------------------------------------------------------               
    def dispose_target_meter
        return if @meter_image == nil
        @meter_sprite.bitmap.dispose
        @meter_sprite.dispose
        @meter_bitmap.dispose
        @meter2_sprite.bitmap.dispose
        @meter2_sprite.dispose
        @meter2_bitmap.dispose
        @meter_image.dispose
        @meter_image = nil
    end    
        
   #--------------------------------------------------------------------------
   # ● Dispose Time Number
   #--------------------------------------------------------------------------                 
   def dispose_time_number
        return if @number_image == nil
        @number_sprite.bitmap.dispose
        @number_sprite.dispose
        @number_bitmap.dispose 
        @number_image.dispose
        @number_image = nil
   end
   
   #--------------------------------------------------------------------------
   # ● Dispose Combo Number
   #--------------------------------------------------------------------------                
   def dispose_combo_number
        return if @cb_number_image == nil
        @cb_number_sprite.bitmap.dispose
        @cb_number_sprite.dispose
        @cb_number_bitmap.dispose 
        @cb_number_image.dispose        
   end     
        
   #--------------------------------------------------------------------------
   # ● Dispose Fire Animation
   #--------------------------------------------------------------------------                
   def dispose_fire_animation
        return if @fire_image == nil
        @fire_bitmap.dispose
        @fire_sprite.bitmap.dispose
        @fire_sprite.dispose
        @fire_image.dispose
        @fire_image = nil
   end     
        
   #--------------------------------------------------------------------------
   # ● Dispose Layout
   #--------------------------------------------------------------------------                
   def dispose_layout
        return if @layout == nil
        @layout.bitmap.dispose
        @layout.dispose      
   end     
  
   #--------------------------------------------------------------------------
   # ● Dispose Background
   #--------------------------------------------------------------------------                 
   def dispose_background
       return if @background == nil
       @background.bitmap.dispose
       @background.dispose           
       @background_2.bitmap.dispose
       @background_2.dispose
       @battleback1_bitmap.dispose
       @battleback2_bitmap.dispose
   end     
  
   #--------------------------------------------------------------------------
   # ● Dispose Score
   #--------------------------------------------------------------------------                 
   def dispose_score
       return if @score_image == nil
       @score_bitmap.dispose
       @score_sprite.bitmap.dispose
       @score_sprite.dispose
       @score_image.dispose
       @score_image = nil
   end     
        
   #--------------------------------------------------------------------------
   # ● Dispose Perform Meter
   #--------------------------------------------------------------------------                 
   def dispose_perform_meter
        return if @p_image == nil 
        @p_bitmap.dispose
        @p_sprite.bitmap.dispose
        @p_sprite.dispose
        @p_image.dispose
        @p_image = nil
   end     
        
   #--------------------------------------------------------------------------
   # ● Dispose Reaction Meter
   #--------------------------------------------------------------------------                 
   def dispose_reaction_meter
       return if @r_image == nil 
       @r_bitmap.dispose
       @r_sprite.bitmap.dispose
       @r_sprite.dispose
       @r_image.dispose
       @r_image = nil
   end
      
   #--------------------------------------------------------------------------
   # ● Dispose Hp Meter
   #--------------------------------------------------------------------------                 
   def dispose_hp_meter
       return if @hp2_image == nil
       @hp2_bitmap.dispose
       @hp2_sprite.bitmap.dispose
       @hp2_sprite.dispose
       @hp2_image.dispose
       @hp2_image = nil
   end     
        
   #--------------------------------------------------------------------------
   # ● Dispose Button
   #--------------------------------------------------------------------------                 
   def dispose_button
       return if @press_image == nil
       @press_bitmap.dispose
       @press_sprite.bitmap.dispose
       @press_sprite.dispose
       @press_image.dispose
       @press_image = nil 
   end    
     
   #--------------------------------------------------------------------------
   # ● Dispose Particles
   #--------------------------------------------------------------------------              
    def dispose_particles
        return if @light_bitmap == nil
        @light_bitmap.each {|sprite| sprite.dispose }
        @light_bitmap = nil
        @viewport_light.dispose if @viewport_light != nil
    end     
    
   #--------------------------------------------------------------------------
   # ● Dispose Flash
   #--------------------------------------------------------------------------                
    def dispose_flash
        return if @flash_bitmap == nil
        @flash_bitmap.each {|sprite| sprite.dispose }
        @flash_bitmap = nil
        @viewport_flash.dispose if @viewport_flash != nil
    end    
    
    #--------------------------------------------------------------------------
    # ● Dispose Info
    #--------------------------------------------------------------------------              
    def dispose_info
        return if @info == nil
        return if @info.bitmap == nil
        @info.bitmap.dispose
        @info.dispose
        @info = nil
    end     
     
  end    
  
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
    
    #--------------------------------------------------------------------------
    # ● Update flash
    #--------------------------------------------------------------------------      
    def update_flash
        return if @flash_bitmap == nil
        @flash_bitmap.each {|sprite| sprite.update }
    end  
    
    #--------------------------------------------------------------------------
    # ● Update Particles
    #--------------------------------------------------------------------------      
    def update_particles
        return if @light_bitmap == nil or @phase < 3
        @light_bitmap.each {|sprite| sprite.update }
    end
    
    #--------------------------------------------------------------------------
    # ● Update Spell Meter
    #--------------------------------------------------------------------------        
    def update_bonus_meter
        @p_sprite.bitmap.clear
        @p_width = @p_image.width * @perform / @perform_max
        @p_src_rect = Rect.new(0, 0, @p_width, @p_height)
        @p_bitmap.blt(0,0, @p_image, @p_src_rect)           
    end  
      
    #--------------------------------------------------------------------------
    # ● Draw Number
    #--------------------------------------------------------------------------  
    def draw_number(x,y,value)
        @number_text = value.abs.to_s.split(//)
        plus_x = -@number_cw * @number_text.size
        for r in 0..@number_text.size - 1
           @number_abs = @number_text[r].to_i 
           @number_src_rect = Rect.new(@number_cw * @number_abs, 0, @number_cw, @number_ch)
           @number_bitmap.blt(plus_x + x + (@number_cw  *  r), y, @number_image, @number_src_rect)        
        end     
    end   
      
    #--------------------------------------------------------------------------
    # ● Refresh Number
    #--------------------------------------------------------------------------  
    def refresh_number
        @number = @total_sec
        @number_sprite.bitmap.clear
        draw_number(@number_cw * 1,0,0) if @min < 10              
        draw_number(@number_cw * 2,0,@min)
        draw_number(@number_cw * 4,0,0) if @sec < 10            
        draw_number(@number_cw * 5,0,@sec)
    end
   
    #--------------------------------------------------------------------------
    # ● Update Flow
    #--------------------------------------------------------------------------  
    def update_flow
        return if @pause  
        @meter_sprite.bitmap.clear
        @meter2_sprite.bitmap.clear      
        @meter_width = @meter_range * @target_hp / @target_maxhp
        @meter_src_rect = Rect.new(@meter_flow, 0,@meter_width, @meter_height)
        @meter_bitmap.blt(0,0, @meter_image, @meter_src_rect)          
        @meter2_src_rect = Rect.new(@meter_flow, @meter_height,@meter2_width, @meter_height)
        @meter2_bitmap.blt(0,0, @meter_image, @meter2_src_rect)          
        @meter_flow += METER_FLOW_SPEED  
        @meter_flow = 0 if @meter_flow >= @meter_image.width - @meter_range   
    end   
      
    #--------------------------------------------------------------------------
    # ● Update Reaction Meter
    #--------------------------------------------------------------------------      
    def update_reaction_meter 
        return if @pause 
        @r_sprite.bitmap.clear
        @r_width = @r_image.width * @reaction_time / @reaction_time_max
        @r_src_rect = Rect.new(0, 0, @r_width, @r_height)
        @r_bitmap.blt(0,0, @r_image, @r_src_rect)       
    end  
    
    #--------------------------------------------------------------------------
    # ● Refresh Stamina Mater
    #--------------------------------------------------------------------------        
    def refresh_stamina_meter  
        @old_stamina = @player_hp 
        @hp2_sprite.bitmap.clear
        @hp2_width = @hp2_image.width * @player_hp / @player_maxhp
        src_rect = Rect.new(0, 0, @hp2_width, @hp2_height)
        @hp2_bitmap.blt(0,0, @hp2_image, src_rect)      
   end   
    
    #--------------------------------------------------------------------------
    # ● Update Fire 
    #--------------------------------------------------------------------------  
    def update_fire 
      return if @pause 
      @fire_flow_speed += 1
      if @fire_flow_speed > FIRE_ANIMATION_SPEED
         @fire_flow += 1
         @fire_flow_speed = 0
         @fire_flow = 0 if @fire_flow == 4
         @fire_refresh = true 
      end
      return if @fire_refresh == false 
      @fire_sprite.bitmap.clear
      @fire_refresh = false
      @fire_src_rect_back = Rect.new(@fire_width * @fire_flow, 0,@fire_width, @fire_image.height)
      @fire_bitmap.blt(0,0, @fire_image, @fire_src_rect_back)        
    end      
    
    #--------------------------------------------------------------------------
    # ● Refresh Press
    #--------------------------------------------------------------------------        
    def refresh_press
        @press_refresh = false
        @press_sprite.zoom_x = 2.00
        @press_sprite.zoom_y = 2.00      
        @press_sprite.bitmap.clear
        if @wait > 0
           @press_src_rect = Rect.new(8 * @press_width, 0, @press_width, @press_height)
        else
           @press_src_rect = Rect.new(@next_key * @press_width, 0, @press_width, @press_height)
        end
        @press_bitmap.blt(0,0, @press_image, @press_src_rect)
        check_key_position
    end  
    
    #--------------------------------------------------------------------------
    # ● Refresh Score
    #--------------------------------------------------------------------------      
    def refresh_score
        @score_sprite.bitmap.clear      
        @score_text = @score_cache.abs.to_s.split(//)
        for r in 0..@score_text.size - 1
           @score_abs = @score_text[r].to_i 
           @score_src_rect = Rect.new(@score_cw * @score_abs, 0, @score_cw, @score_ch)
           @score_bitmap.blt(@score_cw  *  r, 0, @score_image, @score_src_rect)        
        end
        @score_refresh = false if @score == @score_old  
    end    
    
    #--------------------------------------------------------------------------
    # ● Update Score Number
    #--------------------------------------------------------------------------      
    def update_score_number
        @score_refresh = true
        n =  1 * (@score - @score_old).abs / 100
        score_speed = [[n, 9999999].min,1].max
        if @score_old < @score
            @score_cache += score_speed   
            if @score_cache >= @score
               @score_old = @score
               @score_cache = @score
            end              
          elsif @score_old > @score
             @score_cache -= score_speed            
             if @score_cache <= @score
                @score_old = @score
                @score_cache = @score
             end            
          end          
    end  
  
    #--------------------------------------------------------------------------
    # ● Refresh CB Number
    #--------------------------------------------------------------------------        
    def refresh_cb_number
        @combo_old = @combo
        @cb_number_bitmap.clear
        @cb_number_text = @combo.abs.to_s.split(//)
        for r in 0..@cb_number_text.size - 1
           number_abs = @cb_number_text[r].to_i 
           src_rect = Rect.new(@cb_number_cw * number_abs, 0, @cb_number_cw, @cb_number_ch)
           @cb_number_bitmap.blt((@cb_number_cw  *  r), 0, @cb_number_image, src_rect)        
        end
        @cb_number_sprite.ox = (@cb_number_cw * @cb_number_text.size) / 2
    end  
    
    #--------------------------------------------------------------------------
    # ● Update Combo Effect
    #--------------------------------------------------------------------------            
    def update_combo_effect
        return if @combo_animation_duration == 0
        @combo_animation_duration -= 1
        case @combo_animation_duration
            when 21..40
                 @cb_number_sprite.zoom_x += 0.06
                 @cb_number_sprite.zoom_y += 0.06
            when 1..20  
                 @cb_number_sprite.zoom_x -= 0.06
                 @cb_number_sprite.zoom_y -= 0.06            
            else
                 @cb_number_sprite.zoom_x = 1.00
                 @cb_number_sprite.zoom_y = 1.00
                 @combo_animation_duration = 0  
        end
     end
      
    #--------------------------------------------------------------------------
    # ● Update HP Number Effect
    #--------------------------------------------------------------------------                
    def update_button_effect
        return if @press_sprite.zoom_x == 1.00
        @press_sprite.zoom_x -= 0.06
        @press_sprite.zoom_y -= 0.06      
        if @press_sprite.zoom_x <= 1.00
           @press_sprite.zoom_x = 1.00
           @press_sprite.zoom_y = 1.00
        end   
    end  
     
    #--------------------------------------------------------------------------
    # ● Update Background 1
    #--------------------------------------------------------------------------      
    def update_background_1 
        if @back_effect_type == 0
           @background.ox += @back_effect_power_1
           @background.oy += @back_effect_power_2
        else   
           @background.update 
        end  
    end
      
    #--------------------------------------------------------------------------
    # ● Update Background 2
    #--------------------------------------------------------------------------      
    def update_background_2 
        update_breath_effect
        if @back2_effect_type == 0
           @background_2.ox += @back2_effect_power_1
           @background_2.oy += @back2_effect_power_2
        else   
           @background_2.update 
        end  
    end    
    
    #--------------------------------------------------------------------------
    # ● Update Breath Effect
    #--------------------------------------------------------------------------        
   def update_breath_effect
       return if !@breath_effect 
        @breach_effect[1] += 1
        case @breach_effect[1]
           when 0..30
               @breach_effect[0] += 0.0004
           when 31..50
               @breach_effect[0] -= 0.0004
           else  
           @breach_effect[1] = 0
           @breach_effect[0] = 1.truncate
        end
        @background_2.zoom_y = @breach_effect[0]   
   end
   
  end
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
  
    #--------------------------------------------------------------------------
    # ● update
    #--------------------------------------------------------------------------  
    def update
        update_base
        update_sprites      
        update_system
    end   
  
    #--------------------------------------------------------------------------
    # ● Update_base
    #--------------------------------------------------------------------------      
    def update_base
        update_wait
        update_event
        update_pause
    end  
    
    #--------------------------------------------------------------------------
    # ● Update_system
    #--------------------------------------------------------------------------        
    def update_system
        return if !can_update_system?
        update_bonus
        update_reaction_time
        update_timer
        update_timeover if @timer > 0
        update_command    
    end
    
    #--------------------------------------------------------------------------
    # ● Can Update System?
    #--------------------------------------------------------------------------          
    def can_update_system?
        return false if @event_time > 0
        return false if @pause
        return false if @force_pause
        return false if @phase != 3
        return true
    end  
    
    #--------------------------------------------------------------------------
    # ● Update Sprites
    #--------------------------------------------------------------------------    
    def update_sprites
        update_flow
        update_fire
        update_bonus_meter
        update_combo_effect
        update_reaction_meter
        update_button_effect
        update_defeat_target
        update_particles
        update_flash
        update_background_1
        update_background_2 
        update_score_number if @score_old != @score
        refresh_stamina_meter if @old_stamina != @player_hp       
        refresh_number if @number != @total_sec
        refresh_cb_number if @combo_old != @combo      
        refresh_press if @press_refresh
        refresh_score if @score_refresh
    end  
  
    #--------------------------------------------------------------------------
    # ● Update Pause
    #--------------------------------------------------------------------------        
    def update_pause
        return if !can_update_pause?
        if Input.trigger?(Input::A) 
           se_pause
           if @force_pause 
              @force_pause = false
              make_next_command
              @press_sprite.visible = true
              dispose_info
           else   
              @force_pause = true
              @press_sprite.visible = false
              create_info("Info6")
           end  
        end     
    end    
    
    #--------------------------------------------------------------------------
    # ● Can Update Pause
    #--------------------------------------------------------------------------          
    def can_update_pause?
        return false if @event_time > 0
        return false if @pause
        return false if @wait > 0
        return false if @phase != 3
        return true
    end
    
    #--------------------------------------------------------------------------
    # ● Update Defeat Target
    #--------------------------------------------------------------------------        
    def update_defeat_target
        return if @phase != 4
        return if @target == nil
        @target.opacity -= 1     
    end
  
    #--------------------------------------------------------------------------
    # ● update
    #--------------------------------------------------------------------------  
    def update_timer
        @total_sec = @timer / Graphics.frame_rate
        @min = @total_sec / 60
        @sec = @total_sec % 60 
    end  
   
    #--------------------------------------------------------------------------
    # ● update_wait
    #--------------------------------------------------------------------------        
    def update_wait  
        return if @wait == 0
        @wait -= 1 
        if @wait == 0
           make_next_command
        end   
    end     
    
    #--------------------------------------------------------------------------
    # ● Update Reaction Time
    #--------------------------------------------------------------------------          
    def update_reaction_time
        return if @wait > 0
        return if @reaction_time == 0
        @reaction_time -= 1
        if @reaction_time == 0
           execute_wait         
           se_reaction_timeover
           execute_player_damage
           @player_shake_duration = 40
        end   
    end  
    
  end   
  
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
    
    #--------------------------------------------------------------------------
    # ● Update Event
    #--------------------------------------------------------------------------        
    def update_event
        update_event_duration
        return if !can_update_event?    
        @info.opacity -= 10 unless @force_pause 
        if @phase == 6 and @result_sprite != nil
           @result_sprite.opacity -= 10
           @number_sprite.opacity -= 10
        end   
        execute_event if @info.opacity <= 0
     end   
  
    #--------------------------------------------------------------------------
    # ● Update Event Duration
    #--------------------------------------------------------------------------                 
     def update_event_duration
         return if @event_time <= 0
         @event_time -= @event_speed
         @event_time = 0 if @event_time < 0
         update_skip_event
     end
       
    #--------------------------------------------------------------------------
    # ● Can Update  Event?
    #--------------------------------------------------------------------------              
     def can_update_event?
         return false if @event_time > 0
         return false if @info == nil
         return true
     end  
     
    #--------------------------------------------------------------------------
    # * update Skip Event
    #--------------------------------------------------------------------------          
    def update_skip_event
        return false if @event_time == 0
        return false if @phase == 3
        return false if @info.opacity < 60
        if Input.trigger?(Input::C) or
           Input.trigger?(Input::B) 
           @event_time = 0 
           se_cursor
        end
     end
      
    #--------------------------------------------------------------------------
    # ● Execute Event
    #--------------------------------------------------------------------------           
     def execute_event
         case @phase
               when 6;  execute_exit
               when 5;  event_timeover
               when 4;  event_victory
               when 2;  event_battle_start 
               when 1;  event_ready_go
               when 0;  event_tutorial
         end
    end  
    
    
    #--------------------------------------------------------------------------
    # ● Event Time Over
    #--------------------------------------------------------------------------             
    def event_timeover
        execute_exit
    end
      
    #--------------------------------------------------------------------------
    # Event Victory
    #--------------------------------------------------------------------------            
    def event_victory
        create_info("Info7")
        @event_time = 900
        @phase = 6
        check_average_reaction_time
        objects_sprites_visible(false)
        @number_sprite.visible = true
        @number_sprite.x = 420
        @number_sprite.y = 193
        @number_sprite.z = 1000
        make_rank
        create_result_text
        se_result
    end
    
    #--------------------------------------------------------------------------
    # Event Battle Start
    #--------------------------------------------------------------------------          
    def event_battle_start 
        dispose_info
        @pause = false
        @wait = 0
        @phase = 3
        @event_time = 0
        objects_sprites_visible(true)
        make_next_command
    end
    
    #--------------------------------------------------------------------------
    # Event Ready Go
    #--------------------------------------------------------------------------        
    def event_ready_go
        dispose_info
        create_info("Info2")
        @phase = 2 
        @event_time = 160    
    end  
    
    #--------------------------------------------------------------------------
    # Event Tutorial
    #--------------------------------------------------------------------------      
    def event_tutorial
        dispose_info
        create_info("Info1")
        @phase = 1 
        @event_time = 220    
    end 
    
  end
  
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
    
    #--------------------------------------------------------------------------
    # ● Update Gameover
    #--------------------------------------------------------------------------    
    def update_timeover
        return if @pause
        @timer -= 1 
        if @timer == 0
           create_info("Info4")
           se_timeover
           execute_lose
        end
    end  
    
    #--------------------------------------------------------------------------
    # ● Execute_lose
    #--------------------------------------------------------------------------      
    def execute_lose
        update_score_number
        refresh_stamina_meter    
        refresh_number
        refresh_cb_number 
        refresh_score    
        RPG::BGM.fade(5 * 1000)
        @event_time = 180
        @phase = 5
    end
      
    #--------------------------------------------------------------------------
    # ● Execute Game_Over
    #--------------------------------------------------------------------------          
    def execute_exit
        SceneManager.return        
    end
    
    #--------------------------------------------------------------------------
    # ● Execute Victory
    #--------------------------------------------------------------------------        
    def execute_victory 
        @pause = true
        @phase = 4
        dispose_info
        @target_phase = 0 
        create_info("Info3")
        @event_time = 150 
        @target_shake_duration = 180
        @meter_sprite.bitmap.clear
        @press_sprite.visible = false
        RPG::BGM.fade(7 * 1000)
        se_last_blow
        execute_store_record   
    end   
    
    #--------------------------------------------------------------------------
    # ● Execute Store Record
    #--------------------------------------------------------------------------          
    def execute_store_record
        variable_id1 = STORE_SCORE_VARIABLE_ID
        variable_id2 = STORE_COMBO_VARIABLE_ID
        $game_system.melodia_a_record[0] = @max_score if @max_score > $game_system.melodia_a_record[0]
        $game_system.melodia_a_record[1] = @max_combo if @max_combo > $game_system.melodia_a_record[1] 
        $game_variables[variable_id1] = @max_score if @max_score > $game_variables[variable_id1]
        $game_variables[variable_id2] = @max_combo if @max_combo > $game_variables[variable_id2]
        if $game_system.melodia_a[5] != nil
           $game_switches[$game_system.melodia_a[5]] = true
        end   
        $game_map.need_refresh = true 
    end  
    
  end
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
    
   #--------------------------------------------------------------------------
   # ● Check Bonus Limit
   #--------------------------------------------------------------------------                
   def check_bonus_limit
       @perform = @perform_max if @perform > @perform_max
       @perform = 0 if @perform < 0
    end
        
    #--------------------------------------------------------------------------
    # ● Update bonus
    #--------------------------------------------------------------------------                
    def update_bonus
        @perform -= 1 if @perform > 0      
    end  
   
    #--------------------------------------------------------------------------
    # ● Add Bonus Gauge
    #--------------------------------------------------------------------------          
    def add_bonus_gauge
        @perform += @bonus_speed
        check_bonus_limit
    end    
    
  end
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
    
    #--------------------------------------------------------------------------
    # ● Add Score
    #--------------------------------------------------------------------------      
    def add_score
        point = (@perform + rand(@hits) + rand(9)).truncate
        point = 1 if point < 1      
        @score += point
        @max_score = @score if @score > @max_score
    end
    
    #--------------------------------------------------------------------------
    # ● Recuce Score
    #--------------------------------------------------------------------------      
    def reduce_score
        point = ((@score * 5 / 100) + rand(9)).truncate
        point = 1 if point < 1
        @score -= point
        @score = 0 if @score < 0
        @misses += 1
    end
    
    #--------------------------------------------------------------------------
    # ● Execute Player Damage
    #--------------------------------------------------------------------------          
    def execute_player_damage     
        @player_hp -= 1
        @misses += 1
        execute_combo(false)
        if @player_hp <= 0 
           @player_hp = 0         
           create_info("Info5")
           se_statmina_zero
           execute_lose
        end   
    end  
   
    #--------------------------------------------------------------------------
    # ● Execute Wait
    #--------------------------------------------------------------------------            
    def execute_wait
        @wait = 42
        make_next_command(true)
    end    
    
    #--------------------------------------------------------------------------
    # ● Execute Wrong SE
    #--------------------------------------------------------------------------              
    def execute_wrong_se
        se_wrong
    end   
    
    #--------------------------------------------------------------------------
    # ● Wrong Command
    #--------------------------------------------------------------------------            
    def wrong_command
        execute_wait
        execute_wrong_se
        execute_player_damage        
    end  
    
    #--------------------------------------------------------------------------
    # ● Execute Combo
    #--------------------------------------------------------------------------            
    def execute_combo(value = false)
        @combo += 1 if value 
        @combo = 0 if !value
        @max_combo = @combo if @combo > @max_combo
        @cb_number_sprite.zoom_x = 1.00
        @cb_number_sprite.zoom_y = 1.00
        @cb_number_sprite.opacity = 255
        @combo_animation_duration = 40
    end
    
    #--------------------------------------------------------------------------
    # ● Execute Target_Damage
    #--------------------------------------------------------------------------        
    def execute_target_damage
        se_right
        @n_hits += 1
        execute_combo(true)
        rc = @reaction_time_max - @reaction_time
        @reaction_time_score += rc      
        @reaction_time = @reaction_time_max
        add_bonus_gauge
        @flash_bitmap[@next_key].flash_effect
        make_next_command
        @target_hp += 1
        @hits += 1
        add_score
        @target_hp = @target_maxhp if @target_hp > @target_maxhp
        @target_hp = 0 if @target_hp < 0
        execute_victory if @target_hp >=  @target_maxhp 
    end 
    
    #--------------------------------------------------------------------------
    # ● Check Average Reaction Time
    #--------------------------------------------------------------------------          
    def check_average_reaction_time
        hundredths = (@reaction_time_score / 0.6).truncate      
        @reaction_time_average = (hundredths / @n_hits)
    end    
    
    #--------------------------------------------------------------------------
    # ● Make Rank
    #--------------------------------------------------------------------------            
    def make_rank
        if @reaction_time_average.between?(0,15)
           @rank_point += 20
        elsif @reaction_time_average.between?(16,30)   
           @rank_point += 15
        elsif @reaction_time_average.between?(31,45)
           @rank_point += 10
        elsif @reaction_time_average.between?(46,60)  
           @rank_point += 8
        elsif @reaction_time_average.between?(61,75)
           @rank_point += 6      
        elsif @reaction_time_average.between?(76,90)
           @rank_point += 4        
        elsif @reaction_time_average.between?(90,105)
           @rank_point += 2        
        end
        if @misses == 0 
           @rank_point += 15
        elsif @misses == 1 
           @rank_point += 10   
        elsif @misses.between?(2,4)    
           @rank_point += 5
        else
           @rank_point -= @misses
        end
        @rank_point = 0 if @rank_point < 0
        if @rank_point.between?(30,40)
           @rank = "S"
        elsif @rank_point.between?(25,29)   
           @rank = "A"
        elsif @rank_point.between?(20,24)      
           @rank = "B"
        elsif @rank_point.between?(15,19)      
           @rank = "C" 
        elsif @rank_point.between?(10,14)      
           @rank = "D"
        elsif @rank_point.between?(5,9)    
           @rank = "E"
        else   
           @rank = "F"
        end      
    end  
    
    
  end
  
  
  #==============================================================================
  # ■ Scene_Melodia_A
  #==============================================================================
  class Scene_Melodia_A
    
    #--------------------------------------------------------------------------
    # ● Make Next Command
    #--------------------------------------------------------------------------      
    def make_next_command(skip = false)
        return if @phase != 3
        unless skip 
           @next_key = rand(8) 
           @pressed_key = @next_key
           @reaction_time = @reaction_time_max 
        end   
        @press_refresh = true 
    end
      
    #--------------------------------------------------------------------------
    # ● update_command
    #--------------------------------------------------------------------------    
    def update_command      
        return if @wait > 0
        if Input.trigger?(Input::C) #Z 
           @pressed_key = 0
           if @next_key == 0
              execute_target_damage
           else 
              wrong_command
           end  
         elsif Input.trigger?(Input::B) #X
           @pressed_key = 1
           if @next_key == 1
              execute_target_damage
           else 
              wrong_command
           end          
         elsif Input.trigger?(Input::X) #A
           @pressed_key = 2
           if @next_key == 2
              execute_target_damage
           else 
              wrong_command
           end                 
         elsif Input.trigger?(Input::Y) #S
           @pressed_key = 3
           if @next_key == 3
              execute_target_damage
           else 
              wrong_command
           end  
         elsif Input.trigger?(Input::RIGHT)
           @pressed_key = 4
           if @next_key == 4
              execute_target_damage
           else 
              wrong_command
           end          
         elsif Input.trigger?(Input::LEFT) 
           @pressed_key = 5
           if @next_key == 5
              execute_target_damage
           else 
              wrong_command
           end          
         elsif Input.trigger?(Input::DOWN)      
           @pressed_key = 6
           if @next_key == 6
              execute_target_damage
           else 
              wrong_command
           end          
         elsif Input.trigger?(Input::UP) 
           @pressed_key = 7
           if @next_key == 7
              execute_target_damage
           else 
              wrong_command
           end        
        end  
     end  
    
  end
   
  $mog_rgss3_melodia = true    
  