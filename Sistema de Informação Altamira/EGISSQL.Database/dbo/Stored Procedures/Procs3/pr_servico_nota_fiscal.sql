
CREATE  PROCEDURE pr_servico_nota_fiscal
@ic_parametro        int,
@nm_fantasia_empresa varchar(20),
@cd_nota_fiscal      int
as

-------------------------------------------------------------------------------
--Controle da Largura do Campo da descrição do Item da Nota Fiscal por Cliente
-------------------------------------------------------------------------------

declare @qt_tamanho_descricao int

set @qt_tamanho_descricao = 0
select top 1
  @qt_tamanho_descricao = isnull(qt_tam_campo_nota_fiscal,@qt_tamanho_descricao)
from
  Nota_Saida_LayOut
where
  cd_empresa = dbo.fn_empresa() and
  isnull(ic_div_linha_campo,'N') = 'S' and
  cd_campo_nota_fiscal = 63

  
--select @qt_tamanho_descricao

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- NOTA_FISCAL_SAIDA
----------------------------------------------------------------------------
begin
    select
      um.sg_unidade_medida                      as 'UNIDSERV',
      nsi.cd_item_nota_saida                    as 'ITEM_NOTA',
      nsi.cd_servico                            as 'CODIGO',
      nsi.qt_item_nota_saida                    as 'QUANTSERV',
      nsi.ds_servico                            as 'DESCSERV',
      nsi.vl_servico                            as 'VLUNITSERV',
      nsi.vl_iss_servico                        as 'VLISS',
      (nsi.qt_item_nota_saida * nsi.vl_servico) as 'TOTALSERVICO',
      s.nm_servico                              as 'SERVICO'
      into #Servico_Nota_Fiscal
    from
      Nota_Saida_Item nsi
      left outer join Unidade_Medida um   on nsi.cd_unidade_medida = um.cd_unidade_medida
      left outer join Servico s           on s.cd_servico          = nsi.cd_servico
    where
      nsi.cd_nota_saida           = @cd_nota_fiscal and
      nsi.ic_tipo_nota_saida_item = 'S'             --Serviço

    --Rotina Especial para Descrição Técnica

      --Cria a Tabela
   if @qt_tamanho_descricao > 0 
   Begin
      Select top 0 * into #Servico_Observacao from  #Servico_Nota_Fiscal

      declare @nm_servico_item_nota varchar(100)
      declare @ds_item_nota_saida   varchar(8000)
      declare @cd_item_nota_saida   int
      declare @cd_item_verdadeiro   int

      declare cCursor cursor for
      select ITEM_NOTA from #Servico_Nota_Fiscal

      open cCursor

      fetch next from cCursor into @cd_item_nota_saida

      while @@FETCH_STATUS = 0
      begin
        select
          @ds_item_nota_saida   = DESCSERV,
          @nm_servico_item_nota = SERVICO
        from
          #Servico_Nota_Fiscal
        where
          ITEM_NOTA = @cd_item_nota_saida

        --select @ds_item_nota_saida,@nm_servico_item_nota

        if (rtrim(isnull(@ds_item_nota_saida,'')) = rtrim(isnull(@nm_servico_item_nota,'')))
       	begin
          --print(rtrim(@ds_item_nota_saida))
          --print(rtrim(@nm_servico_item_nota))
          insert into #Servico_Observacao
          select *
          from #Servico_Nota_Fiscal
          where ITEM_NOTA = @cd_item_nota_saida

        end    
     	else
        begin
          insert into #Servico_Observacao
          select *
          from #Servico_Nota_Fiscal 
	  where ITEM_NOTA = @cd_item_nota_saida

          declare @Obs    varchar(8000)
          declare @ObsImp varchar(8000)
     					
	  select
            @ObsImp = null,
            @Obs = DESCSERV
          from
            #Servico_Observacao
          where
            ITEM_NOTA = @cd_item_nota_saida

	  print(@Obs)
						
	  update #Servico_Observacao set DESCSERV =  rtrim(substring(DESCSERV,1,@qt_tamanho_descricao))
          where
            ITEM_NOTA = @cd_item_nota_saida


          while (len(@Obs) >= @qt_tamanho_descricao)    
          begin
	    set @Obs = rtrim(substring(@Obs,@qt_tamanho_descricao+1,len(@Obs)))
            set @ObsImp = rtrim(substring(@Obs,1,@qt_tamanho_descricao))
            				
	    print @Obs

	    if len(@Obs) >= @qt_tamanho_descricao
	      insert into #Servico_Observacao (ITEM_NOTA, CODIGO, DESCSERV, UNIDSERV, QUANTSERV, VLUNITSERV, VLISS, TOTALSERVICO, SERVICO)
              (select ITEM_NOTA, CODIGO,  Rtrim(Ltrim(@ObsImp)), '', 0, 0, 0, 0, ''
    	       from #Servico_Nota_Fiscal
    	       where	ITEM_NOTA = @cd_item_nota_saida)

	    -- set @Obs = rtrim(substring(@Obs,@qt_tamanho_descricao+1,len(@Obs)))
       	  end
         
	if ((len(@Obs)<@qt_tamanho_descricao) and (isnull(@Obs,'')<>'')) and (@ObsImp is not null)
          insert into #Servico_Observacao
	    (ITEM_NOTA, CODIGO, DESCSERV, UNIDSERV, QUANTSERV, VLUNITSERV, VLISS, TOTALSERVICO, SERVICO)
            (select
               ITEM_NOTA, CODIGO,    --CODITEM
               @ObsImp,   --DESCRICAO
               '', 0, 0, 0, 0, ''
             from #Servico_Nota_Fiscal 
	     where  ITEM_NOTA = @cd_item_nota_saida)

--         select * from #Servico_Observacao
        end
      	fetch next from cCursor into @cd_item_nota_saida 
    end        
    close cCursor    
    deallocate cCursor      
    --Mostra a Tabela Desmembrada para apresentação    
    select * from #Servico_Observacao    
    drop table #Servico_Observacao  
  end
  else
  begin
    Select * from #Servico_Nota_Fiscal 
  end
    drop table #Servico_Nota_Fiscal    
end


