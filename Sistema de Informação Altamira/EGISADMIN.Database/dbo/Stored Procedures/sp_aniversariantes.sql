
-------------------------------------------------------------------------------
--sp_aniversariantes 
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Usuários Aniversariantes no Período
--Data             : 19.02.2006
--Alteração        : 10.12.2008 - Usuário Inativo
------------------------------------------------------------------------------


CREATE   procedure sp_aniversariantes  
(  
@dt_dia_inicial datetime,  
@dt_dia_final datetime  
)  
as  
  
declare @dt_dia      datetime  
declare @ic_dia_util char(1)  
declare @cd_dias     int  
declare @dt_dia_F    datetime  
  
set @cd_dias = 0  
set @dt_dia = GetDate()  
  
set @dt_dia   = isNull(@dt_dia_inicial, GetDate())  
set @dt_dia_F = isNull(@dt_dia_final, GetDate())  
  
  
select cd_usuario,  
       nm_fantasia_usuario,  
       nm_usuario,  
       dt_nascimento_usuario,  
       cd_departamento,  
       TotAnos =  
      (@dt_dia - dt_nascimento_usuario)  
--       DataCorrente =   
--           Convert(VarChar,RTrim(Convert(Char(2),DatePart(m,dt_nascimento_usuario)))+'/'+  
--                           RTrim(Convert(Char(2),DatePart(d,dt_nascimento_usuario)))+'/'+  
--                                 Convert(Char(4),Year(GetDate())))  
-------  
into #TmpAniversariantesDia  
-------  
from 
  Usuario   
--select * from usuario
where
     isnull(ic_ativo,'A') = 'A'  and   --Usuário Ativo
     (day(dt_nascimento_usuario) >= day(@dt_dia+@cd_dias) and  
      month(dt_nascimento_usuario) >= month(@dt_dia+@cd_dias)) and  
     (day(dt_nascimento_usuario) <= day(@dt_dia_F+@cd_dias) and  
      month(dt_nascimento_usuario) <= month(@dt_dia_F+@cd_dias))    
      and  
      isnull(ic_controle_aniversario,'S') = 'S'  
  
set @ic_dia_util = 'N'  
set @cd_dias = 1  
  
while @ic_dia_util = 'N'   
begin  
   if Exists (select ic_util from  EgisSQL.dbo.Agenda  
              where day(dt_agenda) = day( @dt_dia_F + @cd_dias ) and  
                    month(dt_agenda) = month( @dt_dia_F + @cd_dias ) and  
                    year(dt_agenda) = year( @dt_dia_F + @cd_dias ) )  
   begin  
  
      select @ic_dia_util = IsNull(ic_util,'S')  
      from EgisSQL.dbo.Agenda  
      -- Na comparação específica da data, o Sql considera o horário (DateTime) e não trazia  
      -- nenhum registro  
      where day(dt_agenda) = day( @dt_dia_F + @cd_dias ) and  
            month(dt_agenda) = month( @dt_dia_F + @cd_dias ) and  
            year(dt_agenda) = year( @dt_dia_F + @cd_dias )  
  
      if @ic_dia_util = 'N'   
      begin  
  
         -- Aniversariantes de dias não úteis posteriores  
  
         insert into #TmpAniversariantesDia  
  
         select cd_usuario,  
                nm_fantasia_usuario,  
  nm_usuario,                  
         dt_nascimento_usuario,  
  cd_departamento,  
                TotAnos =   
              ((@dt_dia+@cd_dias) - dt_nascimento_usuario)  
--                DataCorrente =   
--                Convert(VarChar,RTrim(Convert(Char(2),DatePart(m,dt_nascimento_usuario)))+'/'+  
--                                RTrim(Convert(Char(2),DatePart(d,dt_nascimento_usuario)))+'/'+  
--                                      Convert(Char(4),Year(@dt_dia+@cd_dias)))  
         from Usuario  
         where day(dt_nascimento_usuario) = day(@dt_dia_F+@cd_dias) and  
               month(dt_nascimento_usuario) = month(@dt_dia_F+@cd_dias) and  
               isnull(ic_controle_aniversario,'S') = 'S'  
  
         set @cd_dias = @cd_dias + 1  
  
      end  
   end  
   else  
      set @ic_dia_util = 'S'  
  
end  
  
select a.nm_fantasia_usuario     as 'Usuario ',  
       a.nm_usuario     as 'Nome',  
       b.nm_departamento         as 'Departamento',  
       Data =   
          a.dt_nascimento_usuario --+ TotAnos  
from #TmpAniversariantesDia a  
     LEFT OUTER JOIN EgisSql.dbo.Departamento b on (a.cd_departamento = b.cd_departamento)  
order by month(a.dt_nascimento_usuario), day(a.dt_nascimento_usuario)  


