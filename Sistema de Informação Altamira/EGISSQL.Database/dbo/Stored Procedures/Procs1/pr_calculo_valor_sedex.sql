

/****** Object:  Stored Procedure dbo.pr_calculo_valor_sedex    Script Date: 13/12/2002 15:08:14 ******/

CREATE PROCEDURE pr_calculo_valor_sedex

@cd_transportadora int,
@cd_estado_cliente int,
@qt_peso_bruto     float,
@vl_frete          int output

as

declare @ic_frete          char(1)
declare @PesoA             int
declare @PesoB             float
declare @PesoInt           int

select @ic_frete = ic_frete
from transportadora
where cd_transportadora = @cd_transportadora

if @ic_frete = 'S'
begin

   if @qt_peso_bruto < 1.1 
   begin
     select --f.cd_tipo_frete, t.*,  
           top 1 round( (t.vl_ate1kg_tipo_frete/t.pc_taxa_tipo_frete), 2) as vl_frete
     from frete f,
          tipo_frete t
     where f.cd_estado = @cd_estado_cliente and
           f.cd_tipo_frete = t.cd_tipo_frete
   end
   else
   begin

      set @PesoInt = @qt_peso_bruto 
      set @PesoA = @PesoInt - 1
      set @PesoB = @qt_peso_bruto - @PesoInt
    
      select t.*,
             WAux =
               case when @PesoA = 0 then (t.vl_ate1kg_tipo_frete + (1 * t.vl_diferentekg_tipo_frete))
               else (t.vl_ate1kg_tipo_frete + (@PesoA * t.vl_diferentekg_tipo_frete)) end
      into #Tmp
      from frete f,
           tipo_frete t
      where f.cd_estado = @cd_estado_cliente and
            f.cd_tipo_frete = t.cd_tipo_frete

      select 
        sg_tipo_frete,
        pc_taxa_tipo_frete,
        WAux1 = 
        case when (@PesoInt > 1) and (@PesoB > 0) then WAux + vl_diferentekg_tipo_frete
        else WAux end
      into #Tmp1
      from #Tmp

      select @vl_frete = (select top 1
        round((WAux1 / pc_taxa_tipo_frete), 2) --as vl_frete
      from #Tmp1)

   end
       

end
else
      --Select retorna sem "zero" casa transportadora não for sedex
      Select @vl_frete= (select top 1 cast(0 as numeric(25,4)) --as vl_frete
      from tipo_frete where 1=2)

      



