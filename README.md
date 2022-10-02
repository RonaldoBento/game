# game
## Game Educativo - Yuru Yuri - Perfect Math Plus 

<br><img src="./img/logo-bento-projeto.png" alt="logo bento-projeto no formato png"><br>

<br><p>Bem-vindo(a) ao jogo Educacional denominado <strong>Yuru Yuri Perfect Math Plus.</strong>

Como você já sabe, a Matemática é uma parte importante de sua vida. Ela está presente em todos os lugares, inclusive nos Games. Jogo desenvolvido com especificações ao complemento do estudo da Matemática em sua casa, no laser, abordando o Ensino Fundamental do 6° ao 9° ano. Yuru Yuri Perfect Math promovendo conteúdo para o 6° e 7° ano e Yuru Yuri Perfect Math Plus promovendo conteúdo para o 8° e 9° ano.

Gostaria muito de que aceitasse este convite para testar o jogo, participando ativamente de todos os desafios propostos. Vamos Começar?</p>

## Screenshot do Game

<br><img src="./img/fmAdVLr.png" alt="logo do game png"><br>

## QUIZ PERFECT MATH

<br><img src="./img/9vJpWRv.jpeg" alt="logo do game png"><br>

<p> É o principal Mini Game do jogo. Aborda problemas matemáticos para o jogador treinar e exercitar suas habilidades e conhecimento. Ao completa-lo será exibido um encerramento no formato de cutscenes do anime Yuru Yuri (assim como a abertura do jogo) e seguido para os créditos finais. Os outros Mini Games também são apresentados, porém você pode ignorá-los. </p>

## YURUYURI - PERFECT MATH
<br><img src="./img/w5vYMuN.jpeg" alt="logo do game png"><br>

<p>Mini Game Matemático, na qual o objetivo é responder corretamente as perguntas dentro do limite do tempo. Contém quatro níveis de dificuldades: Fácil, Normal, Difícil e Lunático.</p>

## SLIDING PUZZLE GAME

<br><img src="./img/7qPj8rU.png" alt="logo do game png"><br>

<p>Mini Game que consiste em mover blocos até que a imagem esteja completa. Contém quatro modelos com as personagens do anime.</p>

## YURUYURI MELODIA

<br><img src="./img/VxPCxmi.jpeg" alt="logo do game png"><br>

<p>Mini Game com sistema de música, efeitos visuais e jogabilidade rápida e simples. Contém Três modelos com as personagens do anime, além disso, possui três níveis de dificuldades: Fácil, Normal e Difícil.</p><br>

## Ficha Técnica

<ul>
    <li><strong>Criador:</strong> Ronaldo Bento</li>
    <li><strong>Gênero:</strong> Educativo MatemáticoPuzzle Quiz</li>
    <li><strong>Engine:</strong> RPG Maker VX Ace</li>
    <li><strong>Design e Characters & Scenario: </strong>from Yuru Yuri</li>
    <li><strong>Design Logos:</strong> Bruce Azkan</li>
    <li><strong>Idioma:</strong> Português Brasileiro</li>
    <li><strong>Testadores:</strong> Romeo Charlie Lima/Bruna/Junior de Sousa/Gustavo M. Queiróz</li>
    <li><strong>Início do projeto:</strong> 30/09/2017</li>
    <li><strong>Lançamento do projeto:</strong> 03/11/2017</li>
    <li><strong>Duração do jogo:</strong> aproximadamente 40 minutos</li>
</ul>

<a href="https://condadobraveheart.com/threads/yuru-yuri-perfect-math-plus.2840/" target="_blank" rel="external" title="Clique aqui para entrar no site do projeto Educacional"><strong>Clique aqui para entrar no site do projeto Educacional ou utilize o QR Code abaixo</strong></a><br>

<img src="frame.png" alt="tela no formato png"><br>


***

<br><img src="./img/logo.jpg" alt="logo do rpg maker vx ace"><br>

<p>O RPG Maker permite que os usuários criem seus próprios jogos de RPG e com algumas mudanças no sistema pode criar até outros tipos de jogos. Utiliza a linguagem de Programacão:
RGSS (Ruby Game Scripting System) uses the object-oriented scripting language Ruby to develop 2D games for the Windows® platform.</p>

## Exemplo de Script:
```Ruby
#==============================================================================
# ** Window_SaveFile
#------------------------------------------------------------------------------
# Esta janela exibe os arquivos salvos nas telas de salvar e carregar.
#==============================================================================

class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # * Variáveis públicas
  #--------------------------------------------------------------------------
  attr_reader   :selected                 # Estado da seleção
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     height : altura
  #     index  : índice do arquivo salvo
  #--------------------------------------------------------------------------
  def initialize(height, index)
    super(0, index * height, Graphics.width, height)
    @file_index = index
    refresh
    @selected = false
  end
  #--------------------------------------------------------------------------
  # * Renovação
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(normal_color)
    name = Vocab::File + " #{@file_index + 1}"
    draw_text(4, 0, 200, line_height, name)
    @name_width = text_size(name).width
    draw_party_characters(152, 58)
    draw_playtime(0, contents.height - line_height, contents.width - 4, 2)
  end
  #--------------------------------------------------------------------------
  # * Desenho dos personagens do grupo
  #     x : coordenada X
  #     y : coordenada Y
  #--------------------------------------------------------------------------
  def draw_party_characters(x, y)
    header = DataManager.load_header(@file_index)
    return unless header
    header[:characters].each_with_index do |data, i|
      draw_character(data[0], data[1], x + i * 48, y)
    end
  end
  #--------------------------------------------------------------------------
  # * Desenho do tempo de jogo
  #     x     : coordenada X
  #     y     : coordenada Y
  #     width : largura
  #     align : alinhamento
  #--------------------------------------------------------------------------
  def draw_playtime(x, y, width, align)
    header = DataManager.load_header(@file_index)
    return unless header
    draw_text(x, y, width, line_height, header[:playtime_s], 2)
  end
  #--------------------------------------------------------------------------
  # * Definição de estado da seleção
  #     selected : estado da seleção
  #--------------------------------------------------------------------------
  def selected=(selected)
    @selected = selected
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Atualização do cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @selected
      cursor_rect.set(0, 0, @name_width + 8, line_height)
    else
      cursor_rect.empty
    end
  end
end
```


