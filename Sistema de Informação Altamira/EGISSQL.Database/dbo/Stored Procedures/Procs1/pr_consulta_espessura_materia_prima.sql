
CREATE  PROCEDURE pr_consulta_espessura_materia_prima

@qt_espessura_acabada      real,  
@qt_largura                real,
@qt_comprimento            real,  
@cd_tipo_espessura_produto int,
@cd_materia_prima          int,
@ic_redondo                char(1),
@cd_tipo_placa             int,
@ic_tipo_medida            char(1) = 'A', -- (A)cabada,(B)ruta,(R)etifica ou Blanchard,(F)inal ou tangencial
@cd_produto                int = null

as

declare @nm_tipo_produto_espessura char(5)

-- Antes de "substituir" (Ex.: Molde/Base/Placa)
select @nm_tipo_produto_espessura = upper(nm_tipo_produto_espessura)
from tipo_produto_espessura
where cd_tipo_produto_espessura = @cd_tipo_espessura_produto

if @cd_tipo_espessura_produto = 3     -- Placa : do quê ? Tratar como Molde/Base
begin
   if (@nm_tipo_produto_espessura = 'MOLDE' or 
       @nm_tipo_produto_espessura = 'PLACA')
      set @cd_tipo_espessura_produto = 1
   else
      set @cd_tipo_espessura_produto = 2
end

if @cd_tipo_espessura_produto = 4     -- Moldes DME tratar como "Molde"
   set @cd_tipo_espessura_produto = 1

declare @qt_maior_medida        float
declare @pc_especifico          float
declare @qt_pi                  float
declare @ic_sobremetal_esquadro char(1)
declare @ic_tolerancia_sm       char(1)
declare @cd_tipo_calculo        int
declare @ic_medida_zerada       char(1)

set @qt_maior_medida  = @qt_largura
if @qt_comprimento > @qt_largura 
   set @qt_maior_medida = @qt_comprimento

-- **

set @qt_pi                  = (select top 1 qt_calculo_pi from parametro_calculo_orcamento where cd_empresa = 1)
set @cd_tipo_calculo        = (select top 1 cd_tipo_calculo from materia_prima where cd_mat_prima = @cd_materia_prima)
set @ic_medida_zerada       = 'N'

if (@qt_espessura_acabada = 0 and @qt_largura = 0 and @qt_comprimento = 0)
   set @ic_medida_zerada = 'S'

-- **

select @pc_especifico   = qt_peso_especifico_materi,
       @cd_tipo_calculo = cd_tipo_calculo
from materia_prima
where cd_mat_prima = @cd_materia_prima

select @ic_sobremetal_esquadro = ic_sobremetal_orcamento,
       @ic_tolerancia_sm       = ic_tolerancia_sobremetal
from tipo_placa 
where cd_tipo_placa = @cd_tipo_placa

-- **

if @ic_tipo_medida = 'B'  
   set @ic_sobremetal_esquadro = 'N'

-- Tipo 1 = Aços 1 (1045) / 2 (1020)              : Pega bitola + SM da tabela e joga no esquadro
-- Tipo 2 = Aços 3 (P20) / 4 (8620) / 16 (VP420B) : Pega SM e joga em todas as medidas como mm.
-- Tipo 3 = Aço  8 (4140)                         : Pega SM "fixo de 6 mm." e joga em todas as medidas

-- Pega dados das tabelas de Espessuras x Larg. e Comprimento
select top 1 
       nm_espessura =
       case when @cd_tipo_calculo = 1 then b.nm_espessura_polegada 
       else rtrim(cast(b.qt_espessura as varchar(10))) end, 
       nm_espessura_sem_tolerancia =
       case when (@cd_tipo_calculo = 1) and (a.cd_espessura_sem_tol is not null) then
         (select nm_espessura_polegada from espessura b where b.cd_espessura = a.cd_espessura_sem_tol)
       else null end,
       qt_espessura_bruta = b.qt_espessura,
       qt_espessura_bruta_sem_tolerancia =
       case when (a.cd_espessura_sem_tol is not null) then
         (select qt_espessura from espessura b where b.cd_espessura = a.cd_espessura_sem_tol)
       else null end,
       qt_sobremetal =
       case when @ic_medida_zerada = 'S' then 0 else qt_sobremetal_esp_acabada end,
       qt_sobremetal_sem_tolerancia =
       case when (@cd_tipo_calculo = 1) and (a.qt_sobremetal_sem_tol is not null) then
          a.qt_sobremetal_sem_tol
       else null end,
       a.cd_espessura,
       @cd_tipo_espessura_produto as cd_tipo_produto_espessura,
       @nm_tipo_produto_espessura as nm_tipo_produto_espessura,
       a.cd_largura_comprimento
--
into #TmpEspessura
--
from espessura_acabada a
--
inner join espessura b on
a.cd_espessura = b.cd_espessura

inner join largura_comprimento c on
a.cd_largura_comprimento = c.cd_largura_comprimento

where cd_tipo_produto_espessura = @cd_tipo_espessura_produto and
      a.qt_espessura_acabada >= @qt_espessura_acabada and
      a.cd_tipo_calculo = @cd_tipo_calculo and 
     (c.qt_largura >= @qt_maior_medida or c.qt_comprimento >= @qt_maior_medida)

order by cd_tipo_calculo desc,
         qt_espessura_acabada,
        (c.qt_largura * qt_comprimento)

-- **

declare @nm_concatena_medida varchar(5)
if @ic_redondo = 'S'
   set @nm_concatena_medida = ' x Ø ' 
else 
   set @nm_concatena_medida = ' x '

-- **

-- Tentar buscar a espessura em polegada (da Espessura "Bruta informada")

declare @nm_espessura              varchar(10)
declare @qt_espessura_bruta        float
declare @qt_largura_bruta          float
declare @qt_comprimento_bruto      float
declare @qt_sobremetal_esp_acabada float

select @qt_sobremetal_esp_acabada = case when @ic_tolerancia_sm = 'S' then qt_sobremetal 
                                    else isnull(qt_sobremetal_sem_tolerancia, qt_sobremetal) end,
       @qt_espessura_bruta        = case when @ic_tolerancia_sm = 'S' then qt_espessura_bruta 
                                    else isnull(qt_espessura_bruta_sem_tolerancia, qt_espessura_bruta) end
from #TmpEspessura

if @ic_tipo_medida = 'B'
begin
   if @cd_tipo_calculo = 1 
      -- Polegada
      set @nm_espessura = RTrim(( select Top 1 nm_espessura_polegada
                                  from espessura 
                                  where (qt_espessura between (@qt_espessura_acabada-.2) and 
                                                              (@qt_espessura_acabada+.2)) )) 
   else
      -- Milímetro
      set @nm_espessura = rtrim(cast(@qt_espessura_acabada as varchar(10))) -- Acabada é a "Bruta"
   
   if (@nm_espessura is null or @nm_espessura = '') 
      set @nm_espessura = rtrim(cast(@qt_espessura_acabada as varchar(10))) 
   
   declare @cd_espessura_temp int
   set @cd_espessura_temp = (select top 1 cd_espessura from espessura
                             where qt_espessura > (@qt_espessura_acabada-.2)
                             order by qt_espessura)

   declare @qt_espessura_acabada_peso float
   set @qt_espessura_acabada_peso =
    (select top 1 a.qt_espessura_acabada
     from espessura_acabada a
     inner join largura_comprimento c on
     a.cd_largura_comprimento = c.cd_largura_comprimento
     where a.cd_espessura              = @cd_espessura_temp and 
           a.cd_tipo_produto_espessura = @cd_tipo_espessura_produto and 
          (c.qt_largura > @qt_maior_medida or c.qt_comprimento > @qt_maior_medida))

   if isnull(@qt_espessura_acabada_peso,0) = 0 
      set @qt_espessura_acabada_peso = @qt_espessura_acabada - @qt_sobremetal_esp_acabada

   set @qt_espessura_bruta   = @qt_espessura_acabada
   set @qt_largura_bruta     = @qt_largura
   set @qt_comprimento_bruto = @qt_comprimento
   
end
else
begin
   select 
      @nm_espessura = 
      case when @ic_medida_zerada = 'S' then '0' 
      else
        case when @cd_tipo_calculo = 1 and @ic_tolerancia_sm = 'S' then nm_espessura 
             when @cd_tipo_calculo = 1 and @ic_tolerancia_sm = 'N' then isnull(nm_espessura_sem_tolerancia,nm_espessura)
        else
          case when @cd_tipo_espessura_produto <> 5 then
             cast(@qt_espessura_acabada+(case when @ic_sobremetal_esquadro='S' then @qt_sobremetal_esp_acabada else 0 end) as varchar)
          else
             -- Manifold têm um tratamento especial ...
             cast(@qt_espessura_acabada+(case when @ic_sobremetal_esquadro='S' then 10 else 0 end) as varchar)
          end
        end
      end,
      @qt_espessura_bruta =
      case when @ic_medida_zerada = 'S' then 0 
      else
        case when @cd_tipo_calculo = 1 then
               cast(cast(@qt_espessura_bruta as varchar(20)) as decimal(10,1))
             when @cd_tipo_calculo <> 1 and @cd_tipo_espessura_produto <> 5 then 
               cast(cast(@qt_espessura_acabada+(case when @ic_sobremetal_esquadro='S' then @qt_sobremetal_esp_acabada else 0 end) 
                   as varchar(20)) as decimal(10,1))
             else 
               -- Manifold têm um tratamento especial ...
               cast(cast(@qt_espessura_acabada+(case when @ic_sobremetal_esquadro='S' then 10 else 0 end) 
                   as varchar(20)) as decimal(10,1))
        end
      end,
      @qt_largura_bruta     = @qt_largura     + (case when @ic_sobremetal_esquadro='S' then @qt_sobremetal_esp_acabada else 0 end),
      @qt_comprimento_bruto = @qt_comprimento + (case when @ic_sobremetal_esquadro='S' then @qt_sobremetal_esp_acabada else 0 end)
   
   from #TmpEspessura
end

-- **

if @ic_medida_zerada = 'N'
   -- Se for redondo, RETIRA 6 mm de sobremetal na Largura
   if @ic_redondo = 'S' 
      set @qt_largura_bruta = @qt_largura - 6

--
-- Resultado Final
--
select 
  
  medidaacabada = 
     case when @ic_redondo <> 'S' then
       cast(@qt_espessura_acabada as varchar) + @nm_concatena_medida + 
       cast(@qt_largura as varchar) + @nm_concatena_medida + cast(@qt_comprimento as varchar)
     else
       cast(@qt_espessura_acabada as varchar) + @nm_concatena_medida + (case when @qt_largura > 0 then cast(@qt_largura as varchar)+@nm_concatena_medida else '' end) +
       cast(@qt_comprimento as varchar)
  end,
  medidabruta = 
  case when @ic_medida_zerada = 'S' then '0' + @nm_concatena_medida + ' 0' + @nm_concatena_medida + ' 0'
       when @ic_redondo <> 'S' then
          @nm_espessura + @nm_concatena_medida + 
             cast(@qt_largura_bruta as varchar) + @nm_concatena_medida + cast(@qt_comprimento_bruto as varchar)
       else
          @nm_espessura + @nm_concatena_medida + (case when @qt_largura_bruta > 0 then cast(@qt_largura_bruta as varchar)+@nm_concatena_medida else '' end) +
              cast(@qt_comprimento_bruto as varchar)
  end,
  medidaretifica = 
     case when @ic_redondo <> 'S' then
       cast(@qt_espessura_acabada as varchar) + @nm_concatena_medida + ' ' +
       cast(@qt_largura as varchar) + @nm_concatena_medida + ' ' + cast(@qt_comprimento as varchar)
     else
       cast(@qt_espessura_acabada as varchar) + @nm_concatena_medida + ' ' + cast(@qt_comprimento as varchar)
  end,
  @nm_espessura as nm_espessura,
  qt_espessura_bruta = round(@qt_espessura_bruta,2),

  @qt_sobremetal_esp_acabada as qt_sobremetal_esp_acabada,
  @qt_espessura_acabada as qt_espessura_acabada,

  qt_largura_bruta =
  case when @ic_redondo <> 'S' then @qt_largura_bruta else 0 end, -- Se redondo, Largura Bruta = 0

  qt_comprimento_bruto = @qt_comprimento_bruto,

  PesoLiquido =
  -- Tratar placas redondas
  case when @ic_redondo <> 'S' then
     case when @qt_espessura_acabada*@qt_largura*
                                     @qt_comprimento*
                                     @pc_especifico / power(10,6) >= 1 then
        round(((case when @ic_tipo_medida <> 'B' then (cast(cast(@qt_espessura_acabada as varchar(20)) as decimal(10,1)))
                else @qt_espessura_acabada_peso end) *
             (@qt_largura     - (case when @ic_tipo_medida = 'B' then @qt_sobremetal_esp_acabada else 0 end)) *
             (@qt_comprimento - (case when @ic_tipo_medida = 'B' then @qt_sobremetal_esp_acabada else 0 end)) *
              @pc_especifico) / power(10,6) ,2)
     else
        round((cast(cast(@qt_espessura_acabada as varchar(20)) as decimal(10,1))*
              @qt_largura *
              @qt_comprimento *
              @pc_especifico) / power(10,6) ,4)
     end
  else
     -- C/2/100 ^2 * 3.1415 (Pi) * PesoEsp * (Espessura / 100) 
     case when (power((@qt_comprimento/2/100),2) * @qt_PI * @pc_especifico *
                @qt_espessura_acabada ) / 100 >= 1 then
        round((power( (@qt_comprimento/2/100) ,2) * @qt_PI * @pc_especifico *
                       @qt_espessura_acabada / 100) ,2)
     else
        round((power( (@qt_comprimento/2/100) ,2) * @qt_PI * @pc_especifico *
                       @qt_espessura_acabada / 100) ,4)
     end 
  end,

  PesoBruto =
  -- Tratar placas redondas
  case when @ic_redondo <> 'S' then
     case when @qt_espessura_bruta*(@qt_largura * @qt_comprimento *
                               @pc_especifico) / power(10,6) >= 1 then
        round(@qt_espessura_bruta *
              (@qt_largura_bruta * @qt_comprimento_bruto * @pc_especifico) / power(10,6) ,2)
     else
        round(@qt_espessura_bruta *
              (@qt_largura_bruta * @qt_comprimento_bruto * @pc_especifico) / power(10,6) ,4)
     end
  else
     -- C/2/100 ^2 * 3.1415 (Pi) * PesoEsp * (Espessura / 100) 
     case when power(@qt_comprimento_bruto/2/100,2) * @qt_PI * @pc_especifico *
               (@qt_espessura_bruta / 100) >= 1 then
        round( power(@qt_comprimento_bruto/2/100,2) * @qt_PI * @pc_especifico *
           (round(@qt_espessura_bruta,1) / 100) ,2)
     else
        round( power(@qt_comprimento_bruto/2/100,2) * @qt_PI * @pc_especifico *
           (round(@qt_espessura_bruta,1) / 100) ,4)
     end
  end,

  cast(0 as char(20)) as 'Area',
  cast(0 as char(20)) as 'AreaTotal',
  cast(0 as float)    as qt_sobremetal_espessura,
  nm_tipo_produto_espessura,
  cd_tipo_produto_espessura,
  cd_largura_comprimento,
  cd_espessura

from #TmpEspessura
 
