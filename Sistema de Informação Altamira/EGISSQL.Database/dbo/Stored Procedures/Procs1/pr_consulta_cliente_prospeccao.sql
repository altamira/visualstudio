
CREATE  PROCEDURE pr_consulta_cliente_prospeccao  

@ic_parametro integer,  
@nm_fantasia_cliente varchar(15),  
@ic_tipo_consulta char(4) = 'F',  
@cd_usuario int = 0 --Código do usuário  
AS  
  
  declare @cd_vendedor int,  
        @ic_mostrar_vendedor_caption char(1)  
  
  set @cd_vendedor = 0  
  set @ic_mostrar_vendedor_caption = 'N'  
  
  if IsNull(@cd_usuario,0) <> 0  
  begin  
    Select top 1   
    @cd_vendedor = IsNull(u.cd_vendedor,0)   
    from   
    EgisAdmin.dbo.Usuario_Internet u  
    where   
    u.cd_usuario_internet = @cd_usuario  
    and IsNull(u.ic_vpn_usuario,'N') = 'S'  
       
    if IsNull(@cd_vendedor,0) > 0   
      set @ic_mostrar_vendedor_caption = 'S'  
    else  
    begin  
      set @ic_mostrar_vendedor_caption = 'N'  
     set @cd_vendedor = 0  
    end       
  end  
-------------------------------------------------------------------------------------------  
  if @ic_parametro = 1 --Consulta Todos clientes  
-------------------------------------------------------------------------------------------  
  begin  
  
    Select  
      c.cd_cliente,  
      c.nm_fantasia_cliente,  
      c.nm_razao_social_cliente,   
      r.nm_ramo_atividade,  
      f.nm_fonte_informacao,  
      s.nm_status_cliente,  
      c.cd_ddd,   
      c.cd_telefone,  
      ci.nm_cidade,  
      e.sg_estado,  
      c.dt_cadastro_cliente,  
      c.cd_cnpj_cliente,  
      c.cd_cep,  
      rg.nm_cliente_regiao as nm_regiao,  
      c.nm_divisao_area,  
      (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor) as nm_fantasia_vendedor,  
      (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor_interno) as nm_fantasia_vendedor_interno,  
      (Select top 1 nm_mascara_tipo_pessoa from Tipo_Pessoa where cd_tipo_pessoa = c.cd_tipo_pessoa) as  nm_mascara_tipo_pessoa,  
      gc.nm_cliente_grupo,  
      @ic_mostrar_vendedor_caption as ic_mostrar_vendedor_caption,  
      (Select top 1 nm_vendedor from vendedor where cd_vendedor = @cd_vendedor) as nm_vendedor_caption,  
      isnull(c.ic_habilitado_suframa,'N') as ic_habilitado_suframa,  
      c.cd_suframa_cliente,  
      c.cd_tipo_pessoa,  
      tm.nm_tipo_mercado,  
      pa.nm_pais,  
      c.cd_moeda,  
      m.sg_moeda,  
      m.nm_moeda  
    from  
      Cliente c  
        Left Join   
      Ramo_Atividade r  
        On c.cd_ramo_atividade = r.cd_ramo_atividade  
        Left Join   
      Fonte_Informacao f  
        On c.cd_Fonte_Informacao = f.cd_Fonte_Informacao  
        Left Join   
      Status_Cliente s  
        On c.cd_Status_Cliente = s.cd_Status_Cliente  
        Left Join   
      Cidade ci  
        On c.cd_cidade = ci.cd_cidade  
        Left Join   
      Estado e  
        On ci.cd_estado = e.cd_estado  
        Left Join   
      Cliente_Grupo gc  
        On c.cd_cliente_grupo = gc.cd_cliente_grupo  
        Left Join   
      Cliente_Regiao rg  
        On c.cd_regiao = rg.cd_cliente_regiao  
        left outer join  
      Tipo_Mercado tm  
        on c.cd_tipo_mercado = tm.cd_tipo_mercado  
        left outer join  
      Pais pa  
        on c.cd_pais = pa.cd_pais  
        left outer join  
      Moeda m  
        on c.cd_moeda = m.cd_moeda  
   where  
      ((@cd_vendedor = 0) or ((@cd_vendedor > 0) and (c.cd_vendedor = @cd_vendedor)))  
    order by c.nm_fantasia_cliente  
  
  end  
-------------------------------------------------------------------------------------------  
  else if @ic_parametro = 2 --Consulta Somente cliente que começa com o nome fantasia informado  
-------------------------------------------------------------------------------------------  
  begin  
    Select distinct  
      c.cd_cliente,  
      c.nm_fantasia_cliente,  
      c.nm_razao_social_cliente,   
      r.nm_ramo_atividade,  
      f.nm_fonte_informacao,  
      s.nm_status_cliente,  
      c.cd_ddd,   
      c.cd_telefone,  
      ci.nm_cidade,  
      e.sg_estado,  
      c.dt_cadastro_cliente,  
      c.cd_cnpj_cliente,  
      c.cd_cep,  
      rg.nm_cliente_regiao as nm_regiao,  
      c.nm_divisao_area,  
      (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor) as nm_fantasia_vendedor,  
      (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor_interno) as nm_fantasia_vendedor_interno,  
      (Select top 1 nm_mascara_tipo_pessoa from Tipo_Pessoa where cd_tipo_pessoa = c.cd_tipo_pessoa) as  nm_mascara_tipo_pessoa,  
      gc.nm_cliente_grupo,  
   @ic_mostrar_vendedor_caption as ic_mostrar_vendedor_caption,  
   (Select top 1 nm_vendedor from vendedor where cd_vendedor = @cd_vendedor) as nm_vendedor_caption,  
      isnull(c.ic_habilitado_suframa,'N') as ic_habilitado_suframa,  
      c.cd_suframa_cliente,  
      c.cd_tipo_pessoa,  
      tm.nm_tipo_mercado,  
      pa.nm_pais,  
      c.cd_moeda,  
      m.nm_moeda,  
      m.sg_moeda  
    into #Cliente  
    from  
      Cliente c  
        Left Join   
      Ramo_Atividade r  
        on c.cd_ramo_atividade = r.cd_ramo_atividade  
        Left Join   
      Fonte_Informacao f  
        on c.cd_Fonte_Informacao = f.cd_Fonte_Informacao  
        Left Join   
      Status_Cliente s  
        on c.cd_Status_Cliente = s.cd_Status_Cliente              
        Left Join   
      Cidade ci  
        on c.cd_cidade = ci.cd_cidade  
        Left Join   
      Estado e  
        on ci.cd_estado = e.cd_estado  
        Left Join   
      Cliente_Grupo gc  
        on c.cd_cliente_grupo = gc.cd_cliente_grupo  
        Left Join   
      Cliente_Regiao rg  
        on c.cd_regiao = rg.cd_cliente_regiao  
        left outer join  
      Tipo_Mercado tm  
        on c.cd_tipo_mercado = tm.cd_tipo_mercado  
        left outer join  
      Pais pa  
        on c.cd_pais = pa.cd_pais  
        left outer join  
      Moeda m  
        on c.cd_moeda = m.cd_moeda  
    where   
      ((@cd_vendedor = 0) or ((@cd_vendedor > 0) and (c.cd_vendedor = @cd_vendedor)))  
      and (  
      (c.nm_fantasia_cliente =  @nm_fantasia_cliente and @ic_tipo_consulta = 'F') or  
      (c.nm_razao_social_cliente =  @nm_fantasia_cliente and @ic_tipo_consulta = 'R') or  
      (c.cd_cnpj_cliente =  @nm_fantasia_cliente and @ic_tipo_consulta = 'CNPJ' and c.cd_tipo_pessoa = 1) or  
      (c.cd_cnpj_cliente =  @nm_fantasia_cliente and @ic_tipo_consulta = 'CPF' and c.cd_tipo_pessoa = 2)  
  
      )  
    order by c.nm_fantasia_cliente  
  
    if (select count(cd_cliente) from #Cliente) = 1   
      begin  
        select * from #Cliente  
      end  
      else  
      begin  
       Select distinct  
         c.cd_cliente,  
         c.nm_fantasia_cliente,  
         c.nm_razao_social_cliente,   
         r.nm_ramo_atividade,  
         f.nm_fonte_informacao,  
         s.nm_status_cliente,  
         c.cd_ddd,   
         c.cd_telefone,  
         ci.nm_cidade,  
         e.sg_estado,  
         c.dt_cadastro_cliente,  
         c.cd_cnpj_cliente,  
         c.cd_cep,  
         rg.nm_cliente_regiao as nm_regiao,  
         c.nm_divisao_area,  
         (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor) as nm_fantasia_vendedor,  
         (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor_interno) as nm_fantasia_vendedor_interno,  
         (Select top 1 nm_mascara_tipo_pessoa from Tipo_Pessoa where cd_tipo_pessoa = c.cd_tipo_pessoa) as  nm_mascara_tipo_pessoa,  
         gc.nm_cliente_grupo,  
        @ic_mostrar_vendedor_caption as ic_mostrar_vendedor_caption,  
        (Select top 1 nm_vendedor from vendedor where cd_vendedor = @cd_vendedor) as nm_vendedor_caption,  
        isnull(c.ic_habilitado_suframa,'N') as ic_habilitado_suframa,  
        c.cd_suframa_cliente,  
        c.cd_tipo_pessoa,  
        tm.nm_tipo_mercado,  
        pa.nm_pais,  
        c.cd_moeda,  
        m.nm_moeda,  
        m.sg_moeda  
      from  
         Cliente c  
           Left Join   
         Ramo_Atividade r  
           On c.cd_ramo_atividade = r.cd_ramo_atividade  
           Left Join   
         Fonte_Informacao f  
           On c.cd_Fonte_Informacao = f.cd_Fonte_Informacao  
           Left Join   
         Status_Cliente s  
           On c.cd_Status_Cliente = s.cd_Status_Cliente              
           Left Join   
         Cidade ci  
           On c.cd_cidade = ci.cd_cidade  
           Left Join   
         Estado e  
           On ci.cd_estado = e.cd_estado  
           Left Join   
         Cliente_Grupo gc  
           On c.cd_cliente_grupo = gc.cd_cliente_grupo  
           Left Join   
         Cliente_Regiao rg  
           On c.cd_regiao = rg.cd_cliente_regiao  
           LEFT OUTER JOIN  
         Tipo_Mercado tm  
           ON c.cd_tipo_mercado = tm.cd_tipo_mercado  
           LEFT OUTER JOIN  
         Pais pa  
           ON c.cd_pais = pa.cd_pais  
           left outer join  
         Moeda m  
           on c.cd_moeda = m.cd_moeda  
       where   
   ((@cd_vendedor = 0) or ((@cd_vendedor > 0) and (c.cd_vendedor = @cd_vendedor)))  
   and  
         (  
         (c.nm_fantasia_cliente like  @nm_fantasia_cliente+'%' and @ic_tipo_consulta = 'F') or  
         (c.nm_razao_social_cliente like  @nm_fantasia_cliente+'%' and @ic_tipo_consulta = 'R') or  
         (c.cd_cnpj_cliente =  @nm_fantasia_cliente and @ic_tipo_consulta = 'CNPJ' and c.cd_tipo_pessoa = 1) or  
         (c.cd_cnpj_cliente =  @nm_fantasia_cliente and @ic_tipo_consulta = 'CPF' and c.cd_tipo_pessoa = 2)  
   )  
       order by c.nm_fantasia_cliente  
     end  
  end  
  
-------------------------------------------------------------------------------------------  
  else if @ic_parametro = 3 --Abre a consulta mas não traz nenhum cliente  
-------------------------------------------------------------------------------------------  
  begin  
    Select  
      c.cd_cliente,  
      c.nm_fantasia_cliente,  
      c.nm_razao_social_cliente,   
      r.nm_ramo_atividade,  
      f.nm_fonte_informacao,  
      s.nm_status_cliente,  
      c.cd_ddd,   
      c.cd_telefone,  
      ci.nm_cidade,  
      e.sg_estado,  
      c.dt_cadastro_cliente,  
      c.cd_cnpj_cliente,  
      c.cd_cep,  
      rg.nm_cliente_regiao as nm_regiao,  
      c.nm_divisao_area,  
      (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor) as nm_fantasia_vendedor,  
      (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor_interno) as nm_fantasia_vendedor_interno,  
      (Select top 1 nm_mascara_tipo_pessoa from Tipo_Pessoa where cd_tipo_pessoa = c.cd_tipo_pessoa) as  nm_mascara_tipo_pessoa,  
      gc.nm_cliente_grupo,  
   @ic_mostrar_vendedor_caption as ic_mostrar_vendedor_caption,  
   (Select top 1 nm_vendedor from vendedor where cd_vendedor = @cd_vendedor) as nm_vendedor_caption,  
      isnull(c.ic_habilitado_suframa,'N') as ic_habilitado_suframa,  
      c.cd_suframa_cliente,  
      c.cd_tipo_pessoa,  
      tm.nm_tipo_mercado,  
      pa.nm_pais,  
      c.cd_moeda,  
      m.nm_moeda,  
      m.sg_moeda  
    from  
      (Select * from Cliente where 1=2) as  c  
        Left Join   
      Ramo_Atividade r  
        On c.cd_ramo_atividade = r.cd_ramo_atividade  
        Left Join   
      Fonte_Informacao f  
        On c.cd_Fonte_Informacao = f.cd_Fonte_Informacao  
        Left Join   
      Status_Cliente s  
        On c.cd_Status_Cliente = s.cd_Status_Cliente  
        Left Join   
  Cidade ci  
        On c.cd_cidade = ci.cd_cidade  
        Left Join   
      Estado e  
        On ci.cd_estado = e.cd_estado  
        Left Join   
      Cliente_Grupo gc  
        On c.cd_cliente_grupo = gc.cd_cliente_grupo  
        Left Join   
      Cliente_Regiao rg  
        On c.cd_regiao = rg.cd_cliente_regiao  
        LEFT OUTER JOIN  
      Tipo_Mercado tm  
        ON c.cd_tipo_mercado = tm.cd_tipo_mercado  
        LEFT OUTER JOIN  
      Pais pa  
        ON c.cd_pais = pa.cd_pais  
        left outer join  
      Moeda m  
        on c.cd_moeda = m.cd_moeda  
    where  
    ((@cd_vendedor = 0) or ((@cd_vendedor > 0) and (c.cd_vendedor = @cd_vendedor)))  
    order by c.nm_fantasia_cliente  
  end  
-------------------------------------------------------------------------------
--Testando a Stored Procedure
-------------------------------------------------------------------------------
--exec pr_consulta_cliente_prospeccao
