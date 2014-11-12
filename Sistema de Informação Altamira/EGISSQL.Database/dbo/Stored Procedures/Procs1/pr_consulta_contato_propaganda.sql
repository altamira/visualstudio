

/****** Object:  Stored Procedure dbo.pr_consulta_contato_propaganda    Script Date: 13/12/2002 15:08:18 ******/

CREATE PROCEDURE pr_consulta_contato_propaganda
@ic_parametro     int,
@cd_cliente       int,
@ic_brinde        char(1), 
@ic_informativo   char(1),
@ic_maladireta    char(1)


AS


--Cria a tabela temporária

Create table #ResultadoGeral
(
   nm_contato_cliente varchar(40) null, 
   nm_fantasia_contato varchar(15) null, 
   nm_fantasia_cliente varchar(15) null,
   cd_telefone_contato varchar(15) null,
   cd_cliente int null,
   cd_celular varchar(15) null, 
   cd_ramal  varchar(10) null, 
   cd_ddd_contato_cliente  varchar(4) null,           
   nm_condicao varchar(255) null)

-------------------------------------------------------
if @ic_parametro = 1 -- Seleciona todos os Contatos
-------------------------------------------------------

begin

INSERT INTO
           #ResultadoGeral
SELECT     nm_contato_cliente, 
           nm_fantasia_contato,
           (Select top 1 nm_fantasia_cliente from cliente where cd_cliente = Cliente_Contato.cd_cliente)as nm_fantasia_cliente,
           cd_telefone_contato,
           cd_cliente,
           cd_celular, 
           cd_ramal, 
           cd_ddd_contato_cliente,           
           case 
             when IsNull(ic_mala_direta_contato,'N') = 'S' then 'Mala Direta '
             Else ''
           End +
           Case
             when IsNull(ic_informativo_contato,'N') = 'S' then '- Informativo ' 
             Else '' 
           End +
           case
             when IsNull(ic_brinde_contato, 'N')     = 'S' then '- Brinde '
             Else '' 
           end as nm_condicao

FROM       Cliente_Contato

WHERE      IsNull(ic_mala_direta_contato,'N') = 'S' or
           IsNull(ic_informativo_contato,'N') = 'S' or
           IsNull(ic_brinde_contato,'N')      = 'S' 
           
end

-------------------------------------
else -- Escolhe apenas 1 específico.
------------------------------------
begin

INSERT INTO
           #ResultadoGeral
SELECT     nm_contato_cliente, 
           nm_fantasia_contato, 
           (Select top 1 nm_fantasia_cliente from cliente where cd_cliente = Cliente_Contato.cd_cliente)as nm_fantasia_cliente,
           cd_telefone_contato,
           cd_cliente, 
           cd_celular, 
           cd_ramal, 
           cd_ddd_contato_cliente,           
           case 
             when IsNull(ic_mala_direta_contato,'N') = 'S' then 'Mala Direta '
             Else ''
           End +
           Case
             when IsNull(ic_informativo_contato,'N') = 'S' then '- Informativo ' 
             Else '' 
           End +
           case
             when IsNull(ic_brinde_contato, 'N')     = 'S' then '- Brinde '
             Else '' 
           end as nm_condicao

FROM       Cliente_Contato

WHERE      ( (ISNull(ic_brinde_contato, 'N') = 'S') or  ( @ic_brinde = 'X' )  ) and
           ( (IsNull(ic_informativo_contato, 'N') = 'S') or ( @ic_informativo = 'X' ) ) and
           ( (IsNull(ic_mala_direta_contato,'N') = 'S') or ( @ic_maladireta = 'X' ) ) 
           

end

--Verifica se precisa realizar a filtragem dos dados
if @cd_cliente = 0
   Select * from #ResultadoGeral order by nm_contato_cliente
else
   Select * from #ResultadoGeral where cd_cliente = @cd_cliente order by nm_contato_cliente

DROP TABLE #ResultadoGeral



