# Title Perfect Math

#==============================================================================
# +++ MOG - YuruYuri - Perfect Math (1.0) +++
#==============================================================================
# By Moghunter 
# http://www.atelier-rgss.com/
#==============================================================================
# Este script é um minigame, baseado nos personagens do anime Yuru Yuri, 
# na qual o objetivo é responder corretamente as perguntas matemáticas
# dentro do limite do tempo.
# Caso o jogador conseguir responder todas as perguntas, uma switch
# será ativada .
#==============================================================================
# UTILIZAÇÃO
#==============================================================================
# Use o comando abaixo para chamar o script.
# 
# yuruyuri(LEVEL ,NUMBER OF QUESTIONS ,SWITCH_ID)
#
# LEVEL = Definição da dificuldade. (0...3)
# NUMBER OF QUESTIONS = Quantidade de questões
# SWITCH_ID = Definição da switch que será ativada ao final da cena.
#
#==============================================================================
# EX
#
# yuruyuri(1,10,5)
#
#==============================================================================
module MOG_YURUYURI_PERFECT_MATH  
    #Definição do botão de selecionar.  
    BUTTON_SELECT = :C
    #Definição do botão do modo de ação.
    BUTTON_ACTION_MODE = :B
    #Definição do arquivo de música.
    MUSIC_NAME = "YuruYuri"
    #Definição do sons utilizados no sistema.(Opcional)
    SE_START = "V_Start"
    SE_BLOW = "Blow1"
    SE_RIGHT = "V_Right"
    SE_WRONG = "V_Wrong"
    SE_TIMEOVER = "V_Timeover"
    SE_YOU_WIN = "V_You_Win"
    SE_YOU_LOSE = "V_You_Lose"
    #Configuração do nível de dificuldade.
    #
    # LEVEL => [NUMBER RANGE, TIME LIMIT ,HP, SLEEP SPEED]
    #
    # NUMBER RANGE = Valor base para o cálculo.
    # TIME LIMIT = Tempo para responder a pergunta
    # HP = Quantidade de HP ou a quantidade de erros permitidos.
    # SLEEP SPEED = Velocidade para o personagem dormir.
    #
    LEVEL_DATA = {
    0 => [9,1000,9,500],    #Easy
    1 => [99,2000,8,600],   #Normal
    2 => [999,2300,7,700],   #Hard
    3 => [9999,2400,6,800]   #Lunatic
    }    
    #Definição da área de impacto na cabeça.  
    HIT_RANGE = [215,335,55,130]
    #Ativar o medidor de Sono.
    SPEEP_EFFECT = true
    #Definição da posição do medidor de sono.
    SPEEP_POSITION = [35,135]
    #Posição do sprite de aviso de sono.
    SLEEP_WARNING_POSITION = [80,40]
    #Porcentagem que será ativada o sprite de aviso.
    SPEEP_WARNING_PERCENTAGE = 70    
  end
  
  $imported = {} if $imported.nil?
  $imported[:mog_yuruyuri] = true
  
  #==============================================================================
  # ** Cache
  #==============================================================================
  module Cache
    
    #--------------------------------------------------------------------------
    # * Himaadanaa
    #--------------------------------------------------------------------------
    def self.yuruyuri(filename)
        load_bitmap("Graphics/yuruyuri/", filename)
    end
    
  end
  
  #==============================================================================
  # ** Game Temp
  #==============================================================================
  class Game_Temp
  
    attr_accessor :yuruyuri
    
    #--------------------------------------------------------------------------
    # * Initialize
    #--------------------------------------------------------------------------
    alias mog_himaadanaa_initialize initialize
    def initialize      
        @yuruyuri = [0,1,0]
        mog_himaadanaa_initialize
    end
    
  end  
  
  #==============================================================================
  # ** Game Interpreter
  #==============================================================================
  class Game_Interpreter
    
    #--------------------------------------------------------------------------
    # * Yuruyuri
    #--------------------------------------------------------------------------
    def yuruyuri(level,n_questions,switch_id)
        n_questions = 1 if n_questions < 1      
        level = 3 if level > 3   
        $game_temp.yuruyuri = [level,n_questions,switch_id]
        SceneManager.goto(Scene_Yuruyuri)
        wait(1)
    end
    
  end
  
  #==============================================================================
  # ** Scene Yuruyuri
  #==============================================================================
  class Scene_Yuruyuri
    include MOG_YURUYURI_PERFECT_MATH
    
    #--------------------------------------------------------------------------
    # * Main
    #--------------------------------------------------------------------------
    def main
        execute_setup
        execute_loop
        execute_dispose
    end
    
    #--------------------------------------------------------------------------
    # * Execute Setup
    #--------------------------------------------------------------------------
    def execute_setup
        BattleManager.save_bgm_and_bgs
        RPG::BGM.fade(1500)
        difficult_setup
        @phase = 0
        @cursor_pos = [Graphics.width / 2,Graphics.height / 2]
        @cursor_limit = [Graphics.width - 16,Graphics.height - 16]
        @face_index = 0
        @face_animation = 0
        @shake_duration = 0
        @move_number = false
        @number_index = 0      
        @number_set = []
        @number_set_real = 0
        @sleep = [false,0,@lv[3],0]
        @sleep_high = @sleep[2] * SPEEP_WARNING_PERCENTAGE / 100
        @clear_number_speed = 0      
        @event_time = 420
        @particle_index = 0
        @char_animation = [0,1]
        @right_animation = 0
        ctime = Time.new
        @current_sec = [0,ctime.sec]
        create_sprites
    end
    
    #--------------------------------------------------------------------------
    # * Difficult Setup
    #--------------------------------------------------------------------------
    def difficult_setup 
        @level = $game_temp.yuruyuri[0]
        @lv = LEVEL_DATA[@level]
        @number_range = [@lv[0],@lv[0]]
        @input_duration = [@lv[1],@lv[1]]
        @data = [0,0,$game_temp.yuruyuri[1],0]
        @hp = [@lv[2],@lv[2],@lv[2]] 
    end
        
    #--------------------------------------------------------------------------
    # * Execute Loop
    #--------------------------------------------------------------------------
    def execute_loop
        Graphics.transition(60)
        loop do
             Input.update
             update
             Graphics.update
             break if SceneManager.scene != self
        end
    end
    
  end
  
  #==============================================================================
  # ** Scene Yuruyuri
  #==============================================================================
  class Scene_Yuruyuri
    
    #--------------------------------------------------------------------------
    # * Create Sprites
    #--------------------------------------------------------------------------
    def create_sprites
        create_background
        create_light
        create_layout
        create_cursor      
        create_character
        create_number_input
        create_number_data
        create_time_meter
        create_hp_meter
        create_buttons
        create_sleep
        create_animation
        create_wake_up
        create_word
        create_zzz
        create_help_sprite
        create_level_sprite
        create_eyes
        create_picture
    end
    
    #--------------------------------------------------------------------------
    # * Create Animation
    #--------------------------------------------------------------------------
    def create_animation
        @ani_image = Cache.yuruyuri("Animation")
        @ani_data = [0,-1]
        @ani_ch = @ani_image.height
        @ani_cw = @ani_image.width / 7      
        @ani_sprite = Sprite.new
        @ani_sprite.bitmap = Bitmap.new(@ani_cw,@ani_ch)
        @ani_sprite.ox = @ani_cw / 2
        @ani_sprite.oy = @ani_ch / 2
        @ani_sprite.z = 102  
    end
    
    #--------------------------------------------------------------------------
    # * Animation 
    #--------------------------------------------------------------------------
    def animation(id,x,y)     
        @ani_sprite.visible = false
        @ani_id = id ; @ani_sprite.x = x ; @ani_sprite.y = y
        refresh_animation(id)
    end
    
    #--------------------------------------------------------------------------
    # * Refresh Animation
    #--------------------------------------------------------------------------
    def refresh_animation(id)
        @ani_sprite.bitmap.clear
        @ani_sprite.zoom_x = 1.00
        @ani_sprite.zoom_y = @ani_sprite.zoom_x
        @ani_sprite.opacity = 255
        scr_rect = Rect.new(@ani_cw * @ani_id,0,@ani_cw,@ani_ch)
        @ani_sprite.bitmap.blt(0,0,@ani_image,scr_rect)
    end
    
    #--------------------------------------------------------------------------
    # * Create Picture
    #--------------------------------------------------------------------------
    def create_picture
        @picture_image = []
        2.times do |i| @picture_image.push(Cache.yuruyuri("Scene" + i.to_s)) end
        @picture = Sprite.new
        @picture.bitmap = Bitmap.new(Graphics.width, Graphics.height)
        @picture.z = 150
        @picture_phase = -1
    end
    
    #--------------------------------------------------------------------------
    # * Refreh Picture
    #--------------------------------------------------------------------------
    def refresh_picture(index = 0) 
        @picture_phase = 0
        @picture.bitmap.clear if @picture.bitmap != nil
        @picture.bitmap = @picture_image[index]
        @picture.opacity = 0
    end
    
    #--------------------------------------------------------------------------
    # * Update Picture
    #--------------------------------------------------------------------------
    def update_picture
        return if @picture_phase == -1
        case @picture_phase
           when 0
              @picture.opacity += 2
              @picture_phase = 1 if @picture.opacity == 255
           when 1     
              if @hp[0] == 0
                 Audio.se_play("Audio/SE/" + SE_YOU_LOSE, 100, 100) rescue nil
              else
                 Audio.se_play("Audio/SE/" + SE_YOU_WIN, 100, 100) rescue nil
              end                    
              @picture_phase = 2 
           when 2    
              execute_end  if Input.trigger?(:C)
        end      
    end
    
    #--------------------------------------------------------------------------
    # * Execute End
    #--------------------------------------------------------------------------
    def execute_end
        RPG::BGM.fade(1000)
        Graphics.fadeout(1000 * Graphics.frame_rate / 1000)
        BattleManager.replay_bgm_and_bgs
        SceneManager.goto(Scene_Map)
    end  
    
    #--------------------------------------------------------------------------
    # * Create Eyes
    #--------------------------------------------------------------------------
    def create_eyes
        @eyes_sprite = Sprite_Eyes_YuruYuri.new
    end
    
    #--------------------------------------------------------------------------
    # * Crate Help Sprite
    #--------------------------------------------------------------------------
    def create_help_sprite
        @help_image = Cache.yuruyuri("Help")
        @help_cw = @help_image.width 
        @help_ch = @help_image.height / 2
        @help_index = 0
        @help_sprite = Sprite.new
        @help_sprite.bitmap = Bitmap.new(@help_cw,@help_ch)
        @help_sprite_org = [370,260,440,94]
        @help_sprite.x = @help_sprite_org[0]
        @help_sprite.y = @help_sprite_org[1]
        @help_sprite.z = 102
        @help_sprite.opacity = 0
        refresh_help
    end
    
    #--------------------------------------------------------------------------
    # * Set Help
    #--------------------------------------------------------------------------
    def set_help(index)
        @help_index = index
        @help_sprite.opacity = 0
        refresh_help
    end
    
    #--------------------------------------------------------------------------
    # * Refresh Help
    #--------------------------------------------------------------------------
    def refresh_help
        @help_sprite.bitmap.clear
        scr_rect = Rect.new(0,@help_ch * @help_index,@help_cw,@help_ch)
        @help_sprite.bitmap.blt(0,0,@help_image,scr_rect)
        @help_sprite.x = @help_index == 0 ? @help_sprite_org[0] - 150 : @help_sprite_org[0] + 150
        @help_sprite.y = @help_index == 0 ? @help_sprite_org[1] : @help_sprite_org[3]
        return if @help_index != 1
        refresh_data_number(@number_data[3],@data[3],3)
        @number_data[3].x += 150
    end
    
    #--------------------------------------------------------------------------
    # * Create Level Sprite
    #--------------------------------------------------------------------------
    def create_level_sprite
        @level_image = Cache.yuruyuri("Level")
        @level_cw = @level_image.width
        @level_ch = @level_image.height / 4
        @level_sprite = Sprite.new
        @level_sprite.bitmap = Bitmap.new(@level_cw,@level_ch)
        @level_sprite.x = 325
        @level_sprite.y = 4
        @level_sprite.z = 21
        refresh_level
    end
    
    #--------------------------------------------------------------------------
    # * Refresh Level
    #--------------------------------------------------------------------------
    def refresh_level
        @level_sprite.bitmap.clear
        scr_rect = Rect.new(0,@level_ch * @level, @level_cw,@level_ch)
        @level_sprite.bitmap.blt(0,0,@level_image,scr_rect)
    end
    
    #--------------------------------------------------------------------------
    # * Create Word
    #--------------------------------------------------------------------------
    def create_word
        @word_image = Cache.yuruyuri("Word")
        @word_data = [0,0]
        @word_cw = @word_image.width
        @word_ch = @word_image.height / 3
        @word_sprite = Sprite.new
        @word_sprite.bitmap = Bitmap.new(@word_cw,@word_ch)
        @word_sprite.ox = @word_cw / 2
        @word_sprite.oy = @word_ch / 2
        @word_sprite.z = 102
        @word_org = [375 + @word_sprite.ox,220 + @word_sprite.oy]
        @word_sprite.x = @word_org[0]
        @word_sprite.y = @word_org[1]        
    end
    
    #--------------------------------------------------------------------------
    # * Word Set
    #--------------------------------------------------------------------------
    def word_set(value,time = 120)      
        @word_data = [time,value]
        @word_sprite.visible = true
        @word_sprite.zoom_x = value == 0 ? 2.00 : 1.00      
        @word_sprite.zoom_y =  @word_sprite.zoom_x
        @word_sprite.opacity = 255
        refresh_word 
    end
    
    #--------------------------------------------------------------------------
    # * Refresh Word
    #--------------------------------------------------------------------------
    def refresh_word
       case @word_data[1]
          when 0 ; @word_sprite.angle = 0 ; @word_sprite.x = @word_org[0] - 40
          when 1 ; @word_sprite.angle = 30; @word_sprite.x = @word_org[0] - 135
          when 2 ; @word_sprite.angle = 0
        end    
        @word_sprite.bitmap.clear
        src_rect = Rect.new(0,@word_ch * @word_data[1],@word_cw,@word_ch)
        @word_sprite.bitmap.blt(0,0,@word_image,src_rect)
    end
    
    #--------------------------------------------------------------------------
    # * Create Wake UP
    #--------------------------------------------------------------------------
    def create_wake_up
        @wake_animation = 0
        @wake = Sprite.new
        @wake.bitmap = Cache.yuruyuri("Wakeup")
        @wake.visible = false
        @wake.x = SLEEP_WARNING_POSITION[0]
        @wake.y = SLEEP_WARNING_POSITION[1]
        @wake.z = 20      
    end
  
    #--------------------------------------------------------------------------
    # * Create ZZZ
    #--------------------------------------------------------------------------
    def create_zzz      
        @zzz_sprite = []
        5.times do |i| @zzz_sprite.push(Particles_Zzzz.new) end
    end
    
    #--------------------------------------------------------------------------
    # * Create Sleep
    #--------------------------------------------------------------------------
    def create_sleep
        @sprite_sleep = Sprite_sleep_Himaadanaa.new(@sleep)
    end
    
    #--------------------------------------------------------------------------
    # * Create Background
    #--------------------------------------------------------------------------
    def create_background
        @background_scroll = 0
        @background = []
        2.times do |i|
          @background.push(Plane.new) if i == 0
          @background.push(Sprite.new) if i == 1
          @background[i].bitmap = Cache.yuruyuri("Background" + i.to_s)
          @background[i].z = i
        end
    end
    
    #--------------------------------------------------------------------------
    # * Create Light
    #--------------------------------------------------------------------------
    def create_light
        @light = Sprite.new
        @light.bitmap = Cache.yuruyuri("Light")
        @light.blend_type = 1
        @light.z = 2
        @light_animation = [0,0]
        @light.opacity = 0
    end
    
    #--------------------------------------------------------------------------
    # * Create Layout
    #--------------------------------------------------------------------------
    def create_layout
        @layout = Plane.new
        @layout.bitmap = Cache.yuruyuri("Layout")
        @layout.z = 20  
    end
    
    #--------------------------------------------------------------------------
    # * Create Cursor
    #--------------------------------------------------------------------------
    def create_cursor
        @cursor_viewport = Viewport.new
        @cursor_viewport.z = 50
        @cursor = Sprite_Cursor_Himaadanaa.new(@cursor_viewport)
    end
      
    #--------------------------------------------------------------------------
    # * Create Time Meter
    #--------------------------------------------------------------------------
    def create_time_meter
        @time_image = Cache.yuruyuri("Time_Meter")
        @time_cw = @time_image.width
        @time_ch = @time_image.height
        @time_meter = Sprite.new
        @time_meter.bitmap = Bitmap.new(@time_cw,@time_ch)
        @time_meter.angle = 180
        @time_meter.x = 17
        @time_meter.y = 284
        @time_meter.z = 21
        refresh_time_meter
    end
    
    #--------------------------------------------------------------------------
    # * Refresh Time Meter
    #--------------------------------------------------------------------------
    def refresh_time_meter
        @time_meter.bitmap.clear
        range = @input_duration[0] * @time_ch / @input_duration[1]
        src_rect = Rect.new(0,0,@time_cw,range)
        @time_meter.bitmap.blt(0,0,@time_image,src_rect)
    end
    
    #--------------------------------------------------------------------------
    # * Create Hp Meter
    #--------------------------------------------------------------------------
    def create_hp_meter
        @hp_image = Cache.yuruyuri("Hp_Meter")
        @hp_cw = @hp_image.width
        @hp_ch = @hp_image.height
        @hp_meter = Sprite.new
        @hp_meter.bitmap = Bitmap.new(@hp_cw,@hp_ch)
        @hp_meter.x = 435
        @hp_meter.y = 9
        @hp_meter.z = 21
        refresh_hp_meter    
    end
    
    #--------------------------------------------------------------------------
    # * Refresh HP Meter
    #--------------------------------------------------------------------------
    def refresh_hp_meter
        @hp[1] = @hp[0]
        @hp_meter.bitmap.clear
        range = @hp[0] * @hp_cw / @hp[2]
        src_rect = Rect.new(0,0,range,@hp_ch)
        @hp_meter.bitmap.blt(0,0,@hp_image,src_rect)
    end  
    
    #--------------------------------------------------------------------------
    # * Create Character
    #--------------------------------------------------------------------------
    def create_character
        @character_sprite = Sprite_Character_Himaadanaa.new
        @character2_sprite = Sprite_Character2_Himaadanaa.new
    end
    
    #--------------------------------------------------------------------------
    # * Create Number Input
    #--------------------------------------------------------------------------
    def create_number_input
        @number_image1 = Cache.yuruyuri("Number1")
        @number_cw1 = @number_image1.width / 10 
        @number_ch1 = @number_image1.height / 3
        @number_input_org = [[200,365],[170,323]]
        @number_input = []
        2.times do |i|
          @number_input.push(Sprite.new)
          @number_input[i].bitmap = Bitmap.new(286,@number_ch1)
          if i == 1
             @number_input[i].ox = @number_input[i].bitmap.width / 2
             @number_input[i].oy = @number_input[i].bitmap.height / 2
             @number_input_org[i][0] += @number_input[i].ox
             @number_input_org[i][1] += @number_input[i].oy
          end
          @number_input[i].x = @number_input_org[i][0]
          @number_input[i].y = @number_input_org[i][1]
          @number_input[i].z = 101       
        end 
        refresh_cal
    end
    
    #--------------------------------------------------------------------------
    # * Create Number Sprite
    #--------------------------------------------------------------------------
    def refresh_number(sprite,value,image)
        sprite.bitmap.clear
        draw_phase = [0,0]
        loop do 
        rch = draw_phase[0] == 2 ? @number_ch1 * 2 : 0
        rch = @number_ch1 * 3 if draw_phase[0] == 1 or draw_phase[0] == 3
        case draw_phase[0]
           when 0 ; real_value = value[0]
           when 2 ; real_value = value[2]
           when 4 ; real_value = value[1]
           else ;   real_value = 0
        end     
        number = real_value.abs.to_s.split(//)
        for r in 0..number.size - 1
            number_abs = number[r].to_i 
            src_rect = Rect.new(@number_cw1 * number_abs, rch, @number_cw1, @number_ch1)
            sprite.bitmap.blt(@number_cw1 * draw_phase[1], 0, image, src_rect)      
            draw_phase[1] += 1
        end      
        draw_phase[0] += 1
        break if draw_phase[0] > 4
        end
        sprite.x = @number_input_org[1][0] - (draw_phase[1] * (@number_cw1 / 2))
        sprite.zoom_x = 1.50
        sprite.zoom_y = sprite.zoom_y
    end  
  
    #--------------------------------------------------------------------------
    # * Create Number Data
    #--------------------------------------------------------------------------
    def create_number_data
        @number_image2 = Cache.yuruyuri("Number2")
        @number_cw2 = @number_image2.width / 10 
        @number_ch2 = @number_image2.height
        @number_data_org = [[480,33],[510,64],[40,382],[442,115]]
        @number_data = []
        4.times do |i|
          @number_data.push(Sprite.new)
          @number_data[i].bitmap = Bitmap.new(@number_image2.width,@number_ch2)
          @number_data[i].x = @number_data_org[i][0]
          @number_data[i].y = @number_data_org[i][1]
          @number_data[i].z = 25      
          refresh_data_number(@number_data[i],@data[i],i) unless i == 3
        end     
    end
    
    #--------------------------------------------------------------------------
    # * Refresh Data Number
    #--------------------------------------------------------------------------
    def refresh_data_number(sprite,value,index)
        sprite.bitmap.clear
        number = value.abs.to_s.split(//)
        for r in 0..number.size - 1
            number_abs = number[r].to_i 
            src_rect = Rect.new(@number_cw2 * number_abs, 0, @number_cw2, @number_ch2)
            sprite.bitmap.blt(@number_cw2 * r, 0, @number_image2, src_rect)      
        end      
        sprite.x = @number_data_org[index][0] - (number.size * (@number_cw2 / 2))
    end
    
    #--------------------------------------------------------------------------
    # * Create Buttons
    #--------------------------------------------------------------------------
    def create_buttons
        @button_image = Cache.yuruyuri("button")
        @button = []
        13.times do |i| @button.push(Sprite_Button_Himaadanaa.new(i,@button_image)) end
    end
    
  end
  
  #==============================================================================
  # ■ Particles_
  #==============================================================================
  class Particles_Zzzz < Sprite
    
   #--------------------------------------------------------------------------
   # ● Initialize
   #--------------------------------------------------------------------------             
    def initialize(viewport = nil)
        super(viewport)
        @speed_x = 0; @speed_y = 0 ; @type = -1 ; @cpos = [0,0]
        @image = Cache.yuruyuri("Particles")
        @cw = @image.width / 2 ; @ch = @image.height
        @limit = [-@cw,Graphics.width + @cw,-@ch,Graphics.height + @ch]
        self.bitmap = Bitmap.new(@cw,@ch)
        self.z = 15 ; self.opacity = 0
        @width_range = Graphics.width + self.bitmap.width
        @height_range = Graphics.height + self.bitmap.width
        reset_setting
        refresh(-1,@cpos)
        @type = -1
    end  
    
   #--------------------------------------------------------------------------
   # ● Dispose
   #--------------------------------------------------------------------------               
    def dispose_sprites
        self.bitmap.dispose if self.bitmap != nil
        @image.dispose
    end   
    
   #--------------------------------------------------------------------------
   # ● Refresh
   #--------------------------------------------------------------------------             
    def refresh(index = 0,position)
        @type = index
        self.bitmap.clear
        scr_rect = Rect.new(@cw * index,0,@cw,@ch)
        self.bitmap.blt(0,0,@image,scr_rect)
        @cpos = position 
        reset_setting
    end
    
   #--------------------------------------------------------------------------
   # ● Reset Setting
   #--------------------------------------------------------------------------               
    def reset_setting
        self.visible = true
        zoom = (50 + rand(100)) / 100.1
        self.zoom_x = zoom
        self.zoom_y = zoom
        self.angle = rand(360)
        self.opacity = 0      
        if @type == 0
           self.x = 230 + rand(64)
           self.y = 200 + rand(64)
           @speed_y = -(1 + rand(3))
           @speed_x = (1 + rand(2)) 
        else   
           self.opacity = 255 
           self.x = @cpos[0] + rand(32)
           self.y = @cpos[1] + rand(32)         
           d = [rand(2),rand(2)]
           d2 = [(1 + rand(3)),(1 + rand(3))]
           @speed_y = d[0] == 0 ? d2[0] : -d2[0]
           @speed_x = d[1] == 0 ? d2[1] : -d2[1]
        end  
    end
    
   #--------------------------------------------------------------------------
   # ● Update
   #--------------------------------------------------------------------------               
    def update_animation(sleep,index,pos)
        if index == 0
           self.visible = false if !sleep
        else   
           self.opacity -= 15
        end
        self.x += @speed_x
        self.y += @speed_y      
        self.opacity += 5
        refresh(index,pos) if @type != index
        reset_setting if can_reset_setting?(sleep,index) 
    end  
    
   #--------------------------------------------------------------------------
   # ● Can Reset Setting
   #--------------------------------------------------------------------------                 
    def can_reset_setting?(sleep,index)
        return false if @type != 0
        return false if !sleep
        return true if !self.y.between?(@limit[0],@limit[1])
        return true if !self.y.between?(@limit[2],@limit[3])      
        return false
    end  
      
  end
  
  #==============================================================================
  # ** Sprite Sleep Himaadanaa
  #==============================================================================
  class Sprite_sleep_Himaadanaa
    
    include MOG_YURUYURI_PERFECT_MATH
    
    #--------------------------------------------------------------------------
    # * Initialize
    #--------------------------------------------------------------------------
    def initialize(data)
        @data = data
        @org_pos = SPEEP_POSITION
        @np = [@org_pos[0],@org_pos[1]]
        @sleep_layout = Sprite.new
        @sleep_layout.bitmap = Cache.yuruyuri("Sleep_Layout")      
        @sleep_layout.x = -200
        @sleep_layout.y = @np[1]
        @sleep_layout.z = 22
        @sleep_layout.visible = SPEEP_EFFECT
        @sleep_meter_image =Cache.yuruyuri("Sleep_Meter")  
        @sleep_cw = @sleep_meter_image.width
        @sleep_ch = @sleep_meter_image.height
        @sleep_meter = Sprite.new
        @sleep_meter.bitmap = Bitmap.new(@sleep_cw,@sleep_ch)
        @sleep_meter.x = @sleep_layout.x + 7
        @sleep_meter.y = @np[1] + 18
        @sleep_meter.z = 22
        @sleep_meter.visible = SPEEP_EFFECT
        update_meter
    end
      
    #--------------------------------------------------------------------------
    # * Update Meter
    #--------------------------------------------------------------------------
    def update_meter
        @sleep_meter.bitmap.clear
        range = @data[1] * @sleep_cw / @data[2]
        scr_rect = Rect.new(0,0,range,@sleep_ch)
        @sleep_meter.bitmap.blt(0,0,@sleep_meter_image,scr_rect)
    end
      
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
        @sleep_layout.bitmap.dispose
        @sleep_layout.dispose
        @sleep_meter.bitmap.dispose
        @sleep_meter.dispose
        @sleep_meter_image.dispose
    end
    
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update(phase,data)
        return if !SPEEP_EFFECT
        if phase != 1
           @sleep_meter.opacity -= 10
           @sleep_layout.opacity -= 10
           return 
        end
        @sleep_meter.opacity += 10
        @sleep_layout.opacity += 10      
        @data = data
        update_meter
        execute_move(@sleep_layout,0,@sleep_layout.x,@np[0])
        execute_move(@sleep_layout,1,@sleep_layout.y,@np[1])
        execute_move(@sleep_meter,0,@sleep_meter.x,@np[0] + 7)
        execute_move(@sleep_meter,1,@sleep_meter.y,@np[1] + 18)    
    end
    
    #--------------------------------------------------------------------------
    # ● Execute Move
    #--------------------------------------------------------------------------      
    def execute_move(sprite,type,cp,np)
        sp = 5 + ((cp - np).abs / 60)
        if cp > np 
           cp -= sp
           cp = np if cp < np
        elsif cp < np 
           cp += sp
           cp = np if cp > np
        end     
        sprite.x = cp if type == 0
        sprite.y = cp if type == 1
    end   
    
  end
  
  #==============================================================================
  # ** Sprite Button Himaadanaa
  #==============================================================================
  class Sprite_Button_Himaadanaa < Sprite
    
    #--------------------------------------------------------------------------
    # * Initialize
    #--------------------------------------------------------------------------
    def initialize(viewport = nil,index,image)
        super(viewport)
        @image = image
        @cw = @image.width / 13
        @ch = @image.height
        @cw2 = @cw + 6
        @ch2 = @ch + 6
        self.bitmap = Bitmap.new(@cw,@ch)
        self.ox = @cw / 2
        self.oy = @ch / 2
        self.x = -self.ox
        self.y = -self.oy
        self.z = 21
        self.opacity = 255
        @index = index
        @phase = 0
        @np = [0,0]
        refresh_button
        set_button_position(@index)
    end  
  
    #--------------------------------------------------------------------------
    # * Refresh Button
    #--------------------------------------------------------------------------
    def refresh_button
        self.bitmap.clear
        scr_rect = Rect.new(@cw * @index,0,@cw,@ch)
        self.bitmap.blt(0,0,@image,scr_rect)
    end
    
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
        super
        self.bitmap.dispose
    end
    
    #--------------------------------------------------------------------------
    # * Set Button Position
    #--------------------------------------------------------------------------
    def set_button_position(now_index)
        n = [now_index / 4,(@cw2 * 4) * (now_index / 4)]
        rp = [365 + (now_index * @cw2) - n[1], 300 + (n[0]  * @ch2)]
        @np = [rp[0],rp[1]]
        self.x = @np[0] ; self.y = @np[1]
    end
    
    #--------------------------------------------------------------------------
    # * Update Move
    #--------------------------------------------------------------------------
    def update_move(phase,index,sleep)
        return if phase == 0
        if !sleep
            self.opacity += 25
        else   
            self.opacity -= 5 if self.opacity > 125
        end
        update_zoom
        set_button_position(index) if @index == 12
    end
    
    #--------------------------------------------------------------------------
    # * Set Press
    #--------------------------------------------------------------------------
    def set_press
        self.zoom_x = 1.50 
        self.zoom_y = 1.50 
    end
    
    #--------------------------------------------------------------------------
    # * Update Zoom
    #--------------------------------------------------------------------------
    def update_zoom
        return if self.zoom_x == 1.00
        self.zoom_x -= 0.05
        self.zoom_x = 1.00 if self.zoom_x < 1.00
        self.zoom_y = self.zoom_x
    end
   
  end
  
  #==============================================================================
  # ** Sprite Cursor Himaadanaa
  #==============================================================================
  class Sprite_Cursor_Himaadanaa < Sprite
    
    attr_accessor :blow
    
    #--------------------------------------------------------------------------
    # * Initialize
    #--------------------------------------------------------------------------
    def initialize(viewport = nil)
        super(viewport)
        self.bitmap = Cache.yuruyuri("Cursor")
        self.x = Graphics.width / 2
        self.y = Graphics.height / 2
        self.z = 100
        self.opacity = 0
        @phase = 0
        @blow = 0
    end
      
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
        super
        self.bitmap.dispose
    end
    
    #--------------------------------------------------------------------------
    # * Update Move
    #--------------------------------------------------------------------------
    def update_move(nx,ny,phase)
        if phase != 1
           self.visible = false
        else
           self.visible = true
        end
        self.opacity += 25
        update_blow_animation
        execute_move(0,self.x,nx)
        execute_move(1,self.y,ny)
    end
    
    #--------------------------------------------------------------------------
    # * Update Blow Animation
    #--------------------------------------------------------------------------
    def update_blow_animation
        return if self.angle <= 0
        self.angle -= 10
    end
    
    #--------------------------------------------------------------------------
    # * Set blow
    #--------------------------------------------------------------------------
    def set_blow
        @blow = 30
        self.angle = 120
    end
    
    #--------------------------------------------------------------------------
    # ● Execute Move
    #--------------------------------------------------------------------------      
    def execute_move(type,cp,np)
        sp = 5 + ((cp - np).abs / 5)
        if cp > np 
           cp -= sp
           cp = np if cp < np
        elsif cp < np 
           cp += sp
           cp = np if cp > np
        end     
        self.x = cp if type == 0
        self.y = cp if type == 1
    end    
    
  end
  
  #==============================================================================
  # ** Sprite Eyes Yuruyuri
  #==============================================================================
  class Sprite_Eyes_YuruYuri < Sprite
  
    #--------------------------------------------------------------------------
    # * Initialize
    #--------------------------------------------------------------------------
    def initialize(viewport = nil)
        super(viewport)
        @image = Cache.yuruyuri("Eyes")
        @sprite_cw = @image.width 
        @sprite_ch = @image.height / 2        
        @sprite_index = 0
        self.bitmap = Bitmap.new(@sprite_cw,@sprite_ch)
        self.x = 211
        self.y = 130
        self.z = 11
        @cw = self.bitmap.width
        @ch = self.bitmap.height
        @animation = [0,0,10]
        @phase = 0
        refresh_sprite
    end
      
    #--------------------------------------------------------------------------
    # * Refresh Sprite
    #--------------------------------------------------------------------------
    def refresh_sprite
        self.bitmap.clear
        sp_rect = Rect.new(0,@ch * @sprite_index,@cw,@ch)
        self.bitmap.blt(0,0,@image,sp_rect)
    end
    
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
        super
        self.bitmap.dispose
        @image.dispose
    end
      
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update(visible)
        self.visible = visible
        update_animation
    end
    
    #--------------------------------------------------------------------------
    # * Update Animation
    #--------------------------------------------------------------------------
    def update_animation
        @animation[1] += 1
        return if @animation[1] < @animation[2]
        @animation[1] = 0      
        @sprite_index = @sprite_index == 0 ? 1: 0 
        refresh_sprite
    end
    
    #--------------------------------------------------------------------------
    # * Update Shake Effect
    #--------------------------------------------------------------------------
    def update_shake_effect(shake_duration)
        self.x = shake_duration > 0 ? (@org_pos[0] - 5 + rand(10)) : @org_pos[0]
    end
    
  end
  
  #==============================================================================
  # ** Sprite Character Himaadanaa
  #==============================================================================
  class Sprite_Character_Himaadanaa < Sprite
  
    #--------------------------------------------------------------------------
    # * Initialize
    #--------------------------------------------------------------------------
    def initialize(viewport = nil)
        super(viewport)
        @image = Cache.yuruyuri("Character")
        @sprite_cw = @image.width / 5
        @sprite_ch = @image.height         
        @sprite_index = 0
        self.bitmap = Bitmap.new(@sprite_cw,@sprite_ch)
        self.oy = self.bitmap.height
        @org_pos = [(Graphics.width / 2) - (@sprite_cw / 2),
                    (Graphics.height - @sprite_ch) + self.oy]
        self.x = @org_pos[0]
        self.y = @org_pos[1]
        self.z = 10
        @cw = self.bitmap.width
        @ch = self.bitmap.height
        @phase = 0
        @shake_speed = 0
        refresh_sprite(0)
    end
      
    #--------------------------------------------------------------------------
    # * Refresh Sprite
    #--------------------------------------------------------------------------
    def refresh_sprite(sprite_index)
        @sprite_index = sprite_index
        self.bitmap.clear
        sp_rect = Rect.new(@cw * @sprite_index,0,@cw,@ch)
        self.bitmap.blt(0,0,@image,sp_rect)
    end
    
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
        super
        self.bitmap.dispose
        @image.dispose
    end
      
    #--------------------------------------------------------------------------
    # * Update Move
    #--------------------------------------------------------------------------
    def update_anime(phase,sprite_index,shake_duration)
        update_shake_effect(shake_duration)
        refresh_sprite(sprite_index) if @sprite_index != sprite_index
    end   
    
    #--------------------------------------------------------------------------
    # * Update Shake Effect
    #--------------------------------------------------------------------------
    def update_shake_effect(shake_duration)
        self.x = shake_duration > 0 ? (@org_pos[0] - 5 + rand(10)) : @org_pos[0]
    end
    
  end
  
  #==============================================================================
  # ** Sprite Character 2 Himaadanaa
  #==============================================================================
  class Sprite_Character2_Himaadanaa < Sprite
  
    #--------------------------------------------------------------------------
    # * Initialize
    #--------------------------------------------------------------------------
    def initialize(viewport = nil)
        super(viewport)
        @image = Cache.yuruyuri("Character2")
        @sprite_cw = @image.width / 4
        @sprite_ch = @image.height         
        @sprite_index = 0
        self.bitmap = Bitmap.new(@sprite_cw,@sprite_ch)
        self.oy = self.bitmap.height
        @org_pos = [0,(Graphics.height - @sprite_ch) + self.oy]
        self.x = -300#@org_pos[0]
        self.y = @org_pos[1]
        self.z = 101
        self.opacity = 0
        @np = [0,0]
        @cw = self.bitmap.width
        @ch = self.bitmap.height
        @phase = 0
        @refresh_times = 0
        @animation = [0,0,10]
    end
      
    #--------------------------------------------------------------------------
    # * Refresh Sprite
    #--------------------------------------------------------------------------
    def refresh_sprite
        return if @refresh_times > 1 and @animation[2] == 40
        self.bitmap.clear
        sp_rect = Rect.new(@cw * @sprite_index,0,@cw,@ch)
        self.bitmap.blt(0,0,@image,sp_rect)
        @refresh_times += 1
    end
    
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
        super
        self.bitmap.dispose
        @image.dispose
    end
      
    #--------------------------------------------------------------------------
    # * Update Move
    #--------------------------------------------------------------------------
    def update_anime(phase,sprite_index,shake_duration)
        update_fade
        update_animation
        execute_move(0,self.x,@np[0]) 
    end    
    
    #--------------------------------------------------------------------------
    # * Update Animation
    #--------------------------------------------------------------------------
    def update_animation
       # return if @sprite_index == 2
        @animation[1] += 1
        return if @animation[1] < @animation[2]
        @animation[1] = 0      
        @sprite_index = @sprite_index == 0 ? 1: 0 if @animation[2] == 10
        @sprite_index = @sprite_index == 2 ? 3: 2 if @animation[2] == 40
        refresh_sprite
    end
    
    #--------------------------------------------------------------------------
    # * Update Fade
    #--------------------------------------------------------------------------
    def update_fade
        @animation[0] -= 1 if @animation[0] > 0
        self.opacity -= 5 if @animation[0] == 0
    end
    
    #--------------------------------------------------------------------------
    # * animation
    #--------------------------------------------------------------------------
    def animation(type)
        speed = type == 0 ? 10 : 40
        @animation = [90,0,speed]
        self.x = -@sprite_cw
        self.opacity = 255
        @sprite_index = type
        @refresh_times = 0
        refresh_sprite
    end
    
    #--------------------------------------------------------------------------
    # ● Execute Move
    #--------------------------------------------------------------------------      
    def execute_move(type,cp,np)
        sp = 5 + ((cp - np).abs / 10)
        if cp > np 
           cp -= sp
           cp = np if cp < np
        elsif cp < np 
           cp += sp
           cp = np if cp > np
        end     
        self.x = cp if type == 0
        self.y = cp if type == 1
    end     
    
  end
  
  #==============================================================================
  # ** Scene Yuruyuri
  #==============================================================================
  class Scene_Yuruyuri
    
    #--------------------------------------------------------------------------
    # * Execute Dispose
    #--------------------------------------------------------------------------
    def execute_dispose
        Graphics.freeze
        dispose_background
        dispose_light
        dispose_layout
        dispose_cursor
        dispose_character
        dispose_number
        dispose_time_meter
        dispose_hp_meter
        dispose_button
        dispose_sleep
        dispose_animation
        dispose_wake_up
        dispose_word
        dispose_zzz
        dispose_help
        dispose_level_sprite
        dispose_eyes
        dispose_picture
    end  
    
    #--------------------------------------------------------------------------
    # * Dispose Background
    #--------------------------------------------------------------------------
    def dispose_background
        @background.each {|sprite| sprite.bitmap.dispose ; sprite.dispose }
    end  
  
    #--------------------------------------------------------------------------
    # * Dispose Light
    #--------------------------------------------------------------------------
    def dispose_light
        @light.bitmap.dispose
        @light.dispose
    end  
    
    #--------------------------------------------------------------------------
    # * Dispose Picture
    #--------------------------------------------------------------------------
    def dispose_picture      
        @picture.bitmap.dispose if @picture.bitmap != nil
        @picture.dispose
        @picture_image.each {|sprite| sprite.dispose}
    end  
    
    #--------------------------------------------------------------------------
    # * Dispose Eyes
    #--------------------------------------------------------------------------
    def dispose_eyes
        @eyes_sprite.dispose
    end    
    
    #--------------------------------------------------------------------------
    # * Dispose Help
    #--------------------------------------------------------------------------
    def dispose_help
        @help_sprite.bitmap.dispose
        @help_sprite.dispose
        @help_image.dispose
    end  
    
    #--------------------------------------------------------------------------
    # * Dispose Layout
    #--------------------------------------------------------------------------
    def dispose_layout
        @layout.bitmap.dispose
        @layout.dispose
    end  
  
    #--------------------------------------------------------------------------
    # * Dispose Cursor
    #--------------------------------------------------------------------------
    def dispose_cursor
        @cursor.dispose
    end    
    
    #--------------------------------------------------------------------------
    # * Dispose Body
    #--------------------------------------------------------------------------
    def dispose_character
        @character_sprite.dispose
        @character2_sprite.dispose
    end  
    
    #--------------------------------------------------------------------------
    # * Dispose Zzz
    #--------------------------------------------------------------------------
    def dispose_zzz
        @zzz_sprite.each {|sprite| sprite.dispose }
    end    
    
    #--------------------------------------------------------------------------
    # * Dispose Number
    #--------------------------------------------------------------------------  
    def dispose_number
        @number_input.each {|sprite| sprite.dispose }
        @number_data.each {|sprite| sprite.dispose }
        @number_image1.dispose
        @number_image2.dispose 
    end  
  
    #--------------------------------------------------------------------------
    # * Dispose Time Meter
    #--------------------------------------------------------------------------
    def dispose_time_meter
        @time_meter.bitmap.dispose
        @time_meter.dispose
        @time_image.dispose
    end
    
    #--------------------------------------------------------------------------
    # * Dispose Level Sprite
    #--------------------------------------------------------------------------
    def dispose_level_sprite
        @level_sprite.bitmap.dispose
        @level_sprite.dispose
        @level_image.dispose
    end  
    
    #--------------------------------------------------------------------------
    # * Dispose HP Meter
    #--------------------------------------------------------------------------
    def dispose_hp_meter
        @hp_meter.bitmap.dispose
        @hp_meter.dispose
        @hp_image.dispose
    end
    
    #--------------------------------------------------------------------------
    # * Dispose Button
    #--------------------------------------------------------------------------
    def dispose_button
        @button.each {|sprite| sprite.dispose }
        @button_image.dispose
    end    
    
    #--------------------------------------------------------------------------
    # * Dispose Sleep
    #--------------------------------------------------------------------------
    def dispose_sleep
        @sprite_sleep.dispose
    end  
    
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose_animation
        @ani_sprite.bitmap.dispose
        @ani_sprite.dispose
        @ani_image.dispose
    end  
    
    #--------------------------------------------------------------------------
    # * Dispose Wake UP
    #--------------------------------------------------------------------------
    def dispose_wake_up
        @wake.bitmap.dispose
        @wake.dispose
    end  
    
    #--------------------------------------------------------------------------
    # * Dispose Word
    #--------------------------------------------------------------------------
    def dispose_word
        @word_sprite.bitmap.dispose
        @word_sprite.dispose
        @word_image.dispose      
    end  
    
  end
  
  #==============================================================================
  # ** Scene Yuruyuri
  #==============================================================================
  class Scene_Yuruyuri
  
    #--------------------------------------------------------------------------
    # * Update Sprites
    #--------------------------------------------------------------------------
    def update_sprites
        update_background
        update_light
        update_cursor
        update_character
        update_time_meter
        update_hp_meter
        update_button_sprite
        update_number
        update_sleep_sprite
        update_animation
        update_wake_up
        update_word
        update_zzz
        update_help_sprite
        update_eyes
        update_picture
    end 
      
    #--------------------------------------------------------------------------
    # * Update Number
    #--------------------------------------------------------------------------
    def update_number    
        @number_input.each do |i| update_input_zoom(i) end        
    end
    
    #--------------------------------------------------------------------------
    # * Update Sleep Sprite
    #--------------------------------------------------------------------------
    def update_sleep_sprite
        @sprite_sleep.update(@phase,@sleep)
    end    
    
    #--------------------------------------------------------------------------
    # * Update Input Zoom
    #--------------------------------------------------------------------------  
    def update_input_zoom(i)
        return if i.zoom_x == 1.00
        i.zoom_x -= 0.05
        i.zoom_x = 1.00 if i.zoom_x < 1.00
        i.zoom_y = i.zoom_x
    end
    
    #--------------------------------------------------------------------------
    # * Update Time Meter
    #--------------------------------------------------------------------------
    def update_time_meter
        refresh_time_meter
    end
    
    #--------------------------------------------------------------------------
    # * Update HP Meter
    #--------------------------------------------------------------------------
    def update_hp_meter
        refresh_hp_meter if @hp[1] != @hp[0]
    end
    
    #--------------------------------------------------------------------------
    # * Update Background
    #--------------------------------------------------------------------------
    def update_background
        @background_scroll += 1
        return if @background_scroll < 3
        @background_scroll = 0
        @background[0].ox += 1
    end     
    
    #--------------------------------------------------------------------------
    # * update
    #--------------------------------------------------------------------------
    def update_eyes
        @eyes_sprite.update(can_eyes_visible?)
    end   
    
    #--------------------------------------------------------------------------
    # * Can Eyes Visible
    #--------------------------------------------------------------------------
    def can_eyes_visible?
        return false if @face_index != 0
        return true
    end
    
    #--------------------------------------------------------------------------
    # * Update Cursor
    #--------------------------------------------------------------------------
    def update_cursor
        @cursor.update_move(@cursor_pos[0],@cursor_pos[1],@phase)
    end
  
    #--------------------------------------------------------------------------
    # * Update Character
    #--------------------------------------------------------------------------
    def update_character
        @character_sprite.update_anime(@phase,@face_index,@shake_duration) if @char_animation[0] == 0
        @character2_sprite.update_anime(@phase,@face_index,@shake_duration)
    end  
    
    #--------------------------------------------------------------------------
    # * Update Button Sprite
    #--------------------------------------------------------------------------
    def update_button_sprite
        @button.each {|sprite| sprite.update_move(@phase,@number_index,@sleep[0])}
    end    
  
    #--------------------------------------------------------------------------
    # * Update Animation
    #--------------------------------------------------------------------------
    def update_animation
        return if @ani_id == -1
        return if @ani_id == 2 and @char_animation[0] > 45
        @ani_sprite.visible = true
        if [0,2,3,4,5,6].include?(@ani_id)
           @ani_sprite.zoom_x += 0.02; @ani_sprite.opacity -= 4 
        elsif @ani_id == 1
              @ani_sprite.y += 2 if @ani_sprite.opacity > 200
              @ani_sprite.opacity -= 2        
        end
        @ani_sprite.zoom_y = @ani_sprite.zoom_x      
        @ani_id = -1 if @ani_sprite.opacity == 0
    end  
    
    #--------------------------------------------------------------------------
    # * Update Help Sprite
    #--------------------------------------------------------------------------
    def update_help_sprite
        if @move_number
           @help_sprite.opacity += 5
           if @help_sprite.x < @help_sprite_org[0]
              @help_sprite.x += 5 
              @help_sprite.x = @help_sprite_org[0] if @help_sprite.x > @help_sprite_org[0]
           elsif @help_sprite.x > @help_sprite_org[0]   
              @help_sprite.x -= 5 
              @help_sprite.x = @help_sprite_org[0] if @help_sprite.x < @help_sprite_org[0]
              @number_data[3].x -= 5
           end
        else
           @help_sprite.opacity -= 5
           @help_sprite.x += 5 if @help_sprite.opacity > 0
        end
        @number_data[3].opacity = @help_sprite.opacity 
        @number_data[3].visible = rq_visible?
    end  
    
    #--------------------------------------------------------------------------
    # * Rq Visible
    #--------------------------------------------------------------------------
    def rq_visible?
        return false if @char_animation[1] != 0
        return false if @char_animation[0] == 0
        return true
    end
    
    #--------------------------------------------------------------------------
    # * Update Word
    #--------------------------------------------------------------------------
    def update_word
        return if !@word_sprite.visible
        @word_data[0] -= 1
        case @word_data[1]
          when 0 ; @word_sprite.zoom_x -= 0.02 if @word_sprite.zoom_x > 1.00
          when 1 ; @word_sprite.x = @word_org[0] + rand(30) - 135
          when 2 ; @word_sprite.x = @word_org[0] + rand(30) - 65
        end
        @word_sprite.zoom_y = @word_sprite.zoom_x
        @word_sprite.opacity -= 5 if @word_data[0] <= 0
        if @word_sprite.opacity == 0 
           @word_sprite.x = @word_org[0]
           @word_sprite.visible = false
        end
    end  
    
    #--------------------------------------------------------------------------
    # * Can Show Wake UP?
    #--------------------------------------------------------------------------
    def can_show_wake_up?
        return false if @sleep[1] < @sleep_high
        return false if @phase != 1
        return true
    end  
    
    #--------------------------------------------------------------------------
    # * Update Wake UP
    #--------------------------------------------------------------------------
    def update_wake_up
        if can_show_wake_up?
           update_wake_up_animation
        else
           @wake.visible = false
        end
    end  
    
    #--------------------------------------------------------------------------
    # * Update Wake UP Animation
    #--------------------------------------------------------------------------
    def update_wake_up_animation
        @wake.visible = true
        @wake_animation += 1
        case @wake_animation
          when 1..30
              @wake.opacity = 255
          when 31..60
              @wake.opacity = 0
          else
             @wake_animation = 0
        end
    end    
    
    #--------------------------------------------------------------------------
    # * Update Zzz
    #--------------------------------------------------------------------------
    def update_zzz
        @zzz_sprite.each {|sprite| sprite.update_animation(@sleep[0],@particle_index,@cursor_pos)}
    end     
    
    #--------------------------------------------------------------------------
    # * Update Light
    #--------------------------------------------------------------------------
    def update_light
        @light_animation[0] += 1
        case @light_animation[0]
          when 1..180#1..360
               @light_animation[1] += 1 if @light_animation[1] < 100
          when 181..540#361..1000
               @light_animation[1] -= 1 if @light_animation[1] > 0
          else
            @light_animation = [0,0]
        end
        @light.opacity = @light_animation[1] + 0
    end  
    
  end
  
  #==============================================================================
  # ** Scene Yuruyuri
  #==============================================================================
  class Scene_Yuruyuri
    
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
        update_current_time
        update_phase
        update_sprites
        if can_update_system?
           update_command
           update_system
        end
    end  
    
    #--------------------------------------------------------------------------
    # * Can Update System
    #--------------------------------------------------------------------------
    def can_update_system?
        return false if @event_time > 0      
        return false if @phase != 1
        return true
    end
    
    #--------------------------------------------------------------------------
    # * Update Phase
    #--------------------------------------------------------------------------
    def update_phase      
        return if @event_time == 0
        @event_time -= 1
        update_start_phase if @phase == 0
        if @event_time == 0
           ctime = Time.new
           @current_sec = [0,ctime.sec]        
           if @phase == 0
              @phase = 1 
              Audio.bgm_play("Audio/BGM/" +  MUSIC_NAME.to_s, 100, 100) rescue nil
              clear_numbers
           end
           refresh_picture(1) if @phase == 2
           refresh_picture(0) if @phase == 3
        end
    end
    
    #--------------------------------------------------------------------------
    # * Update Start Phase
    #--------------------------------------------------------------------------
    def update_start_phase
        animation(5,265,220) if @event_time == 360
        Sound.play_cursor if @event_time == 360
        animation(4,265,220) if @event_time == 270
        Sound.play_cursor if @event_time == 270
        animation(3,265,220) if @event_time == 180 
        Sound.play_cursor if @event_time == 180
        if @event_time == 90
           animation(6,265,220) 
           Audio.se_play("Audio/SE/" + SE_START, 100, 100) rescue nil
        end
    end
    
    #--------------------------------------------------------------------------
    # * Update System
    #--------------------------------------------------------------------------
    def update_system
        @shake_duration -= 1 if @shake_duration > 0
        update_wrong_animation
        update_face_animation  
        update_sleep
        update_time
    end
    
    #--------------------------------------------------------------------------
    # * Update Wrong Animation
    #--------------------------------------------------------------------------
    def update_wrong_animation
        return if @char_animation[0] == 0
        @char_animation[0] -= 1
        return if @char_animation[0] > 0
        if @char_animation[1] == 0
           animation(1,335,120)
           set_face(3,70,true)
         else
           set_face(2,70)
        end
        refresh_cal
        set_help(0)      
    end
      
    #--------------------------------------------------------------------------
    # * Update Sleep
    #--------------------------------------------------------------------------
    def update_sleep
        return if !SPEEP_EFFECT
        return if @char_animation[0] > 0
        @sleep[1] += 1      
        if @sleep[1] >= @sleep[2]
           @sleep[1] = @sleep[2] 
           @sleep[0] = true
           @particle_index = 0
           set_face(1,20) unless @face_index == 4
           clear_numbers_sleep
        else   
           @sleep[0] = false
        end   
        @sleep[1] = 0 if @sleep[1] < 0
    end
    
    #--------------------------------------------------------------------------
    # * Update time
    #--------------------------------------------------------------------------
    def update_time
        return if @char_animation[0] > 0
        @input_duration[0] -= 1
        if @input_duration[0] == 0
           @input_duration[0] = @input_duration[1]
           @data[1] += 1                
           execute_damage(1)
           word_set(2)
           set_face(4,70)         
           clear_numbers
           Audio.se_play("Audio/SE/" + SE_TIMEOVER, 100, 100) rescue nil         
        end
    end
    
    #--------------------------------------------------------------------------
    # * Update Current Time
    #--------------------------------------------------------------------------
    def update_current_time
        @current_sec[0] += 1
        return if @current_sec[0] < 20
        ctime = Time.new
        clear_numbers_time if can_clear_time_number?(ctime)
        @current_sec = [0,ctime.sec]
        
    end
    
    #--------------------------------------------------------------------------
    # * Can Clear Time Number
    #--------------------------------------------------------------------------
    def can_clear_time_number?(ctime)
        return false if ctime.sec.between?(0,5)
        return true if (ctime.sec - @current_sec[1]).abs > 2
        return false 
    end  
      
    #--------------------------------------------------------------------------
    # * Update Face Animation
    #--------------------------------------------------------------------------
    def update_face_animation
        return if @face_animation == 0
        @face_animation -= 1
        @face_index = 0 if @face_animation == 0
    end 
    
    #--------------------------------------------------------------------------
    # * Set Face
    #--------------------------------------------------------------------------
    def set_face(index = 1,duration = 60,shake = false)
        index = 1 if index < 1
        @face_animation = duration
        @face_index = index
        @shake_duration = duration if shake
    end
    
    #--------------------------------------------------------------------------
    # * Refresh Cal
    #--------------------------------------------------------------------------
    def refresh_cal
        return if @phase == 0
        nr = @number_range
        val = [rand(3),rand(nr[0]),rand(nr[1])]
        cal = []
        cal[0] = val[1] > val[2] ? val[1] : val[2]
        cal[1] = val[1] < val[2] ? val[1] : val[2]
        cal[1] = 1 if cal[1] < 1 and val[0] == 3
        cal[2] = val[0]
        case val[0]
           when 0; cal[3] = cal[0] + cal[1]
           when 1; cal[3] = cal[0] - cal[1]
           when 2; cal[3] = cal[0] * cal[1]
           when 3; cal[3] = cal[0] / cal[1]
        end
        @number_set_real = cal[3].truncate
        @data[3] = @number_set_real
        refresh_number(@number_input[1],cal,@number_image1)    
    end  
    
    #--------------------------------------------------------------------------
    # * Execute Damage HP
    #--------------------------------------------------------------------------
    def execute_damage(value)
        pre_hp = @hp[0]
        @hp[0] -= value      
        set_face(3,70,true) if @hp[0] < pre_hp
        set_face(2,60) if @hp[0] > pre_hp
        execute_gameover if @hp[0] <= 0
        @hp[0] = @hp[2] if @hp[0] > @hp[2]
        @sleep[1] = 0
    end    
    
    #--------------------------------------------------------------------------
    # * Execute Gameover
    #--------------------------------------------------------------------------
    def execute_gameover
        @hp[0] = 0 
        @event_time = 120
        @phase = 3
        RPG::BGM.fade(2000)      
    end
    
    #--------------------------------------------------------------------------
    # * Execute Victory
    #--------------------------------------------------------------------------
    def execute_victory
        $game_switches[$game_temp.yuruyuri[2]] = true
        @event_time = 120
        @phase = 2
        RPG::BGM.fade(2000)
    end
    
    #--------------------------------------------------------------------------
    # * Update Command
    #--------------------------------------------------------------------------  
    def update_command
        if @move_number
           update_command_number
        else            
           update_command_action
        end
    end
    
  end
  
  #==============================================================================
  # ** Scene Yuruyuri
  #==============================================================================
  class Scene_Yuruyuri
    
    #--------------------------------------------------------------------------
    # * Uddate Command Number
    #--------------------------------------------------------------------------  
    def update_command_number
        move_cursor_number(4) if Input.trigger?(:DOWN)
        move_cursor_number(-4) if Input.trigger?(:UP)
        move_cursor_number(-1) if Input.trigger?(:LEFT)
        move_cursor_number(1) if Input.trigger?(:RIGHT)
        return if @char_animation[0] > 0
        execute_action_number if Input.trigger?(BUTTON_SELECT)
        cancel_command_number if Input.trigger?(BUTTON_ACTION_MODE)
    end
    
    #--------------------------------------------------------------------------
    # * Move Cursor
    #--------------------------------------------------------------------------  
    def move_cursor_number(d)
        pre_index = @number_index
        if can_force_number_index?(d)
           check_cursor_position
           Sound.play_cursor if @number_index != pre_index
           return
        end
        @number_index += d
        @number_index = pre_index if @number_index < 0 or @number_index > 11
        check_cursor_position
        Sound.play_cursor if @number_index != pre_index
    end
    
    #--------------------------------------------------------------------------
    # * Can Force Number index?
    #--------------------------------------------------------------------------  
    def can_force_number_index?(d)
        if [0,4,8].include?(@number_index) and d == -1   
           @number_index = @number_index + 3
           return true
        elsif [3,7,11].include?(@number_index) and d == 1   
           @number_index = @number_index - 3 
           return true
        elsif @number_index.between?(0,3) and d == -4
           @number_index = @number_index + 8
           return true
        elsif @number_index.between?(8,11) and d == 4
           @number_index = @number_index - 8
           return true
        end
        return false  
    end
        
    #--------------------------------------------------------------------------
    # * Check Cursor Position
    #--------------------------------------------------------------------------  
    def check_cursor_position
        n = [@number_index / 4,(43 * 4) * (@number_index / 4)]
        rp = [360 + (@number_index * 43) - n[1], 305 + (n[0]  * 43)]
        @cursor_pos = [rp[0],rp[1]]  
    end
    
    #--------------------------------------------------------------------------
    # * Execute Action Number
    #--------------------------------------------------------------------------  
    def execute_action_number
        Sound.play_ok
        @button[@number_index].set_press
        case @number_index
             when 0..9 ; set_number
             when 10  ;  execute_back
             when 11  ;  execute_ok
        end
    end
    
    #--------------------------------------------------------------------------
    # * Cancel Number
    #--------------------------------------------------------------------------  
    def cancel_command_number
        Sound.play_cancel
        @number_index = 0 ; @cursor_pos = [420,160] ; @move_number = false
    end
  
    #--------------------------------------------------------------------------
    # * Set Number
    #--------------------------------------------------------------------------  
    def set_number      
        return if @number_set.size > 8      
        @number_set.push(@number_index)
        refresh_number_input(@number_input[0],@number_set, @number_image1)
    end  
    
    #--------------------------------------------------------------------------
    # * Create Number Sprite
    #--------------------------------------------------------------------------
    def refresh_number_input(sprite,value,image)
        return if value.size > 9
        sprite.bitmap.clear
        for i in 0...value.size
            src_rect = Rect.new(@number_cw1 * value[i], @number_ch1, @number_cw1, @number_ch1)
            sprite.bitmap.blt(@number_cw1 * i, 0, image, src_rect)      
        end      
        sprite.x = @number_input_org[0][0] - (value.size * (@number_cw1 / 2))
    end   
    
    #--------------------------------------------------------------------------
    # * Execute OK
    #--------------------------------------------------------------------------  
    def execute_ok
        return if @sleep[0]
        number = @number_set_real.abs.to_s.split(//)
        right = @number_set.size > 0 ? true : false
        right = false if @number_set.size != number.size
        for i in 0...number.size
            if number[i].to_i != @number_set[i].to_i
               right = false
               break
            end
        end
        if right
           execute_right
        else   
           execute_wrong
        end   
        clear_numbers
    end  
    
    #--------------------------------------------------------------------------
    # * Execute Right
    #--------------------------------------------------------------------------  
    def execute_right
        @data[0] += 1 ; @data[2] -= 1
        @data[2] = 0 if @data[2] < 0
        set_face(2,90)
        @sleep[0] = false ;  @sleep[1] = 0      
        word_set(0)
        @character2_sprite.animation(2)
        @char_animation = [90,1] 
        animation(2,265,220)
        execute_victory if @data[2] == 0
        Audio.se_play("Audio/SE/" + SE_RIGHT, 100, 100) rescue nil
    end
    
    #--------------------------------------------------------------------------
    # * Execute Wrong
    #--------------------------------------------------------------------------  
    def execute_wrong
        execute_damage(1) 
        @data[1] += 1
        @char_animation = [90,0] 
        word_set(1)
        @character_sprite.refresh_sprite(3)
        @character2_sprite.animation(0)
        set_help(1)
        Sound.play_buzzer
        Audio.se_play("Audio/SE/" + SE_WRONG, 100, 100) rescue nil
    end       
    
    #--------------------------------------------------------------------------
    # * Execute back
    #--------------------------------------------------------------------------  
    def execute_back
        return if @number_set.size == 0
        Sound.play_cancel
        @number_set.delete_at(@number_set.size - 1)
        refresh_number_input(@number_input[0],@number_set, @number_image1)
    end
    
    #--------------------------------------------------------------------------
    # * Clear Number
    #--------------------------------------------------------------------------  
    def clear_numbers
        @number_set.clear
        @number_set_real = 0
        @input_duration[0] = @input_duration[1]
        refresh_cal
        refresh_number_input(@number_input[0],@number_set, @number_image1)
        refresh_data_number(@number_data[0],@data[0],0)  
        refresh_data_number(@number_data[1],@data[1],1)  
        refresh_data_number(@number_data[2],@data[2],2)
    end
    
    #--------------------------------------------------------------------------
    # * Clear Number
    #--------------------------------------------------------------------------  
    def clear_numbers_time
        @number_set.clear
        @number_set_real = 0
        refresh_cal
        refresh_number_input(@number_input[0],@number_set, @number_image1)
        refresh_data_number(@number_data[0],@data[0],0)  
        refresh_data_number(@number_data[1],@data[1],1) 
        refresh_data_number(@number_data[2],@data[2],2)
    end  
    
    #--------------------------------------------------------------------------
    # * Clear Number
    #--------------------------------------------------------------------------  
    def clear_numbers_sleep
        @clear_number_speed += 1
        return if @clear_number_speed < 10
        @clear_number_speed = 0
        @number_set.clear
        @number_set_real = 0
        refresh_cal
        refresh_number_input(@number_input[0],@number_set, @number_image1)
    end  
    
  end
  
  #==============================================================================
  # ** Scene Yuruyuri
  #==============================================================================
  class Scene_Yuruyuri
    
    #--------------------------------------------------------------------------
    # * Uddate Command Action
    #--------------------------------------------------------------------------  
    def update_command_action
        move_cursor(0) if Input.press?(:DOWN)
        move_cursor(1) if Input.press?(:UP)
        move_cursor(2) if Input.press?(:LEFT)
        move_cursor(3) if Input.press?(:RIGHT)
        execute_action if Input.trigger?(BUTTON_SELECT)    
    end
    
    #--------------------------------------------------------------------------
    # * Move Cursor
    #--------------------------------------------------------------------------  
    def move_cursor(d)
        x = 0; y = 0      
        x = d == 2 ? -cursor_speed : cursor_speed if d.between?(2,3)
        y = d == 1 ? -cursor_speed : cursor_speed if d.between?(0,1)
        @cursor_pos[0] += x
        @cursor_pos[1] += y
        check_screen_limit
        @move_number = can_move_number?
        if @move_number
           check_cursor_position
           set_help(0)
        end
    end
      
    #--------------------------------------------------------------------------
    # * Move Cursor
    #--------------------------------------------------------------------------  
    def can_move_number?
        return false if @cursor_pos[0] < 320
        return false if @cursor_pos[1] < 265
        @number_index = 0
        @help_sprite.x = @help_sprite_org[0] - 100
        @help_sprite.opacity = 0
        return true
    end
    
    #--------------------------------------------------------------------------
    # * Cursor Speed
    #--------------------------------------------------------------------------  
    def cursor_speed
        return 5
    end
    
    #--------------------------------------------------------------------------
    # * Check Screen Limit
    #--------------------------------------------------------------------------  
    def check_screen_limit
        @cursor_pos[0] = 0 if @cursor_pos[0] < 0
        @cursor_pos[0] = @cursor_limit[0] if @cursor_pos[0] > @cursor_limit[0]
        @cursor_pos[1] = 0 if @cursor_pos[1] < 0
        @cursor_pos[1] = @cursor_limit[1] if @cursor_pos[1] > @cursor_limit[1]  
    end
    
    #--------------------------------------------------------------------------
    # * Execute Action
    #--------------------------------------------------------------------------  
    def execute_action
        ep = @face_index == 0 ? [0,0] : [0,64]
        if @cursor_pos[0].between?(HIT_RANGE[0],HIT_RANGE[1] + ep[0]) and @cursor_pos[1].between?(HIT_RANGE[2],HIT_RANGE[3] + ep[1])
           @cursor_pos[1] = HIT_RANGE[3] if @cursor_pos[1] > HIT_RANGE[3]
           @sleep[1] -= 25
           @particle_index = 1
           @zzz_sprite.each {|sprite| sprite.refresh(1,@cursor_pos) }
           set_face(4,20,true)
           animation(0,@cursor_pos[0],@cursor_pos[1])
           Audio.se_play("Audio/SE/" + SE_BLOW, 100, 100)
           @cursor.set_blow
        end
    end
    
  end