CREATE TABLE [dbo].[Documento_Arquivo_Magnetico] (
    [cd_documento_magnetico]        INT           NOT NULL,
    [nm_documento_magnetico]        VARCHAR (40)  NULL,
    [sg_documento_magnetico]        CHAR (10)     NULL,
    [cd_usuario]                    INT           NULL,
    [dt_usuario]                    DATETIME      NULL,
    [ic_envio_recebimento]          CHAR (1)      NULL,
    [nm_local_arquivo]              VARCHAR (100) NULL,
    [nm_extensao_arquivo]           VARCHAR (3)   NULL,
    [nm_mascara_arquivo]            VARCHAR (20)  NULL,
    [cd_modulo]                     INT           NULL,
    [ic_intercalar_detalhe]         CHAR (1)      NULL,
    [ic_tipo_formatacao]            CHAR (3)      NULL,
    [ic_relatorio_retorno_dinamico] CHAR (1)      NULL,
    [cd_orgao_solicitante]          INT           NULL,
    [ic_obrigatorio_documento]      CHAR (1)      NULL,
    [dt_ultimo_proc_documento]      DATETIME      NULL,
    [nm_obs_documento]              VARCHAR (40)  NULL,
    [ic_multa_documento]            CHAR (1)      NULL,
    [ic_ativo_documento]            CHAR (1)      NULL,
    [ic_parametro_generico]         CHAR (1)      NULL,
    [cd_classe]                     INT           NULL,
    [ic_pipe_documento]             CHAR (1)      NULL,
    [cd_procedimento]               INT           NULL,
    [cd_banco]                      INT           NULL,
    CONSTRAINT [PK_Documento_Arquivo_Magnetico] PRIMARY KEY CLUSTERED ([cd_documento_magnetico] ASC),
    CONSTRAINT [FK_Documento_Arquivo_Magnetico_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco]),
    CONSTRAINT [FK_Documento_Arquivo_Magnetico_Orgao_Solicitante] FOREIGN KEY ([cd_orgao_solicitante]) REFERENCES [dbo].[Orgao_Solicitante] ([cd_orgao_solicitante])
);


GO

create trigger td_documento_magnetico
on Documento_Arquivo_Magnetico
after delete

as

----------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2006
----------------------------------------------------------------------------------------------------
--Trigger       : Microsoft SQL Server                2000
--Autor(es)     : Igor Gama
--Banco de Dados: EgisSql
--Objetivo      : Trigger para exclusão de todas as tabelas relacionadas com o arquivo magnético
--                qdo modificações em Conta_Banco_Lancamento
--Data          : 11.04.2006
--Atualizado    : 
----------------------------------------------------------------------------------------------------

begin
  
  --select * from documento_arquivo_magnetico

  declare @cd_documento        int
  declare @cd_sessao_documento int

  Select
    @cd_documento = cd_documento_magnetico
--  Into
--    #Tabela
  from
    deleted

  --Verificação de todas as tabelas relacionadas para exclusão completa do arquivo

  --Campos  
  --select * from campo_arquivo_magnetico  

  select
    cd_documento_magnetico,
    cd_sessao_arquivo_magneti
  into
    #Campo
  from 
    sessao_arquivo_magnetico
  where 
    cd_documento_magnetico = @cd_documento

   while exists( select top 1 cd_documento_magnetico from #Campo )
   begin
     select
       top 1
       @cd_sessao_documento = cd_sessao_arquivo_magneti
     from
       #Campo
     
  
     delete from campo_arquivo_magnetico
     where
       cd_sessao_documento = @cd_sessao_documento

     delete from #Campo
     where
       cd_documento_magnetico    = @cd_documento and
       cd_sessao_arquivo_magneti = @cd_sessao_documento
            
  end
 
  --Sessão
  --select * from sessao_arquivo_magnetico
  delete from sessao_arquivo_magnetico where cd_documento_magnetico = @cd_documento

  --Filtros
  --select * from filtro_arquivo_magnetico
  delete from filtro_arquivo_magnetico where cd_documento_magnetico = @cd_documento

  --Parâmetros de Geração
  --select * from parametro_arquivo_magnetico
  delete from parametro_arquivo_magnetico where cd_documento_magnetico = @cd_documento

  --Parâmetros de Atualização
  --select * from atualizacao_arquivo_magnetico
  delete from atualizacao_arquivo_magnetico where cd_documento_magnetico = @cd_documento


end

