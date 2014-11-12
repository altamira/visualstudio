
-------------------------------------------------------------------------------
--pr_consulta_cliente_delivery
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Cliente para Entrega
--Data             : 09/12/2004
--Alteração        : 04.04.2006
--                 : 07.04.2006
--                 : 11.04.2006 - Pesquisa pelo Celular
--                 : 31.07.2007 - Consulta de Cliente - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_cliente_delivery
   @ic_parametro integer     = 0,    -- 0 - Telefone -- 1 --Fantasia --2 Cliente --3 Contrato --4 Endereço
   @nm_pesquisa  varchar(50) = ''
as


if ( @ic_parametro=0 ) or ( @ic_parametro=1 ) or (@ic_parametro = 2)
begin

Select 
   c.cd_cliente,
   c.nm_fantasia_cliente,
   c.nm_razao_social_cliente,
   c.nm_email_cliente,
   c.dt_cadastro_cliente,
   c.cd_status_cliente,
   c.cd_identifica_cep,
   c.cd_cep,
   c.nm_endereco_cliente,
   c.cd_numero_endereco,
   c.nm_complemento_endereco,
   c.nm_bairro,
   c.cd_cidade,
   c.cd_estado,
   c.cd_pais,
   c.cd_ddd,
   c.cd_telefone,
   c.cd_vendedor
into #PesquisaCliente
From
   Cliente c Left Join 
   Cidade ci on c.cd_cidade = ci.cd_cidade Left Join 
   Estado e  on ci.cd_estado = e.cd_estado 
where

   isNull(c.cd_telefone,'')        like (Case @ic_parametro
                                            when 0 then
                                              @nm_pesquisa + '%'
                                            else
                                              isNull(c.cd_telefone,'')
                                            end) and
  
   isNull(c.nm_fantasia_cliente,'') like (Case @ic_parametro
                                               when 1 then
                                                 @nm_pesquisa + '%'
                                               else
                                                 isNull(c.nm_fantasia_cliente,'')
                                               end) 
  

order by 
   c.nm_fantasia_cliente


--Verifica se existe registro na tabela de Pesquisa

if exists ( select top 1 cd_cliente from #PesquisaCliente )
begin
  
  --select * from cliente

  Select 
    c.cd_cliente,
    c.nm_fantasia_cliente,
    c.nm_razao_social_cliente,
    c.nm_email_cliente,
    c.dt_cadastro_cliente,
    c.cd_status_cliente,
    c.cd_identifica_cep,
    c.cd_cep,
    c.nm_endereco_cliente,
    c.cd_numero_endereco,
    c.nm_complemento_endereco,
    c.nm_bairro,
    c.cd_cidade,
    c.cd_estado,
    c.cd_pais,
    c.cd_ddd,
    c.cd_telefone,
    cd_vendedor
  into #PesquisaClienteCelular
  From
    Cliente c Left Join 
    Cidade ci on c.cd_cidade = ci.cd_cidade Left Join 
    Estado e  on ci.cd_estado = e.cd_estado 
  where
   isNull(c.cd_celular_cliente,'') like (Case @ic_parametro
                                            when 1 then
                                              @nm_pesquisa + '%'
                                            else
                                              isNull(c.cd_celular_cliente,'')
                                            end) 

   order by 
     c.nm_fantasia_cliente

   insert into #PesquisaCliente
    select * from #PesquisaClienteCelular

end

  --Mostra os dados da Pesquisa

  select * from #PesquisaCliente

end

--Pesquisa de Contratos

if @ic_parametro=3
begin
  Select 
   c.cd_cliente,
   c.nm_fantasia_cliente,
   c.nm_razao_social_cliente,
   c.nm_email_cliente,
   c.dt_cadastro_cliente,
   c.cd_status_cliente,
   c.cd_identifica_cep,
   c.cd_cep,
   c.nm_endereco_cliente,
   c.cd_numero_endereco,
   c.nm_complemento_endereco,
   c.nm_bairro,
   c.cd_cidade,
   c.cd_estado,
   c.cd_pais,
   c.cd_ddd,
   c.cd_telefone,
   c.cd_vendedor
  From
--select * from contrato_concessao
   Contrato_Concessao cc 
   left join Cliente c on c.cd_cliente = cc.cd_cliente
   Left Join Cidade ci on c.cd_cidade = ci.cd_cidade 
   Left Join Estado e  on ci.cd_estado = e.cd_estado 
  where

   isNull(cc.nm_contrato_carac,'') = (Case @ic_parametro
                                            when 2 then
                                              @nm_pesquisa
                                            else
                                              isNull(cc.nm_contrato_carac,'')
                                           end) 
order by 
   c.nm_fantasia_cliente


end

--Pesquisa Pelo Endereço
--select * from cliente

if @ic_parametro=4
begin

  --Pesquisa Pelo Endereço
  Select 
    c.cd_cliente,
    c.nm_fantasia_cliente,
    c.nm_razao_social_cliente,
    c.nm_email_cliente,
    c.dt_cadastro_cliente,
    c.cd_status_cliente,
    c.cd_identifica_cep,
    c.cd_cep,
    c.nm_endereco_cliente,
    c.cd_numero_endereco,
    c.nm_complemento_endereco,
    c.nm_bairro,
    c.cd_cidade,
    c.cd_estado,
    c.cd_pais,
    c.cd_ddd,
    c.cd_telefone,
   c.cd_vendedor
  From
    Cliente c Left Join 
    Cidade ci on c.cd_cidade = ci.cd_cidade Left Join 
    Estado e  on ci.cd_estado = e.cd_estado 
  where

   isNull(c.nm_endereco_cliente,'') like (Case @ic_parametro
                                            when 1 then
                                              @nm_pesquisa + '%'
                                            else
                                              isNull(c.nm_endereco_cliente,'')
                                            end) 
  order by 
     c.nm_fantasia_cliente


end


