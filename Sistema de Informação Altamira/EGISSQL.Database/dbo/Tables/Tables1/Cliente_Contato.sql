CREATE TABLE [dbo].[Cliente_Contato] (
    [cd_cliente]                INT           NOT NULL,
    [cd_contato]                INT           NOT NULL,
    [nm_contato_cliente]        VARCHAR (40)  NULL,
    [nm_fantasia_contato]       VARCHAR (15)  NULL,
    [cd_ddd_contato_cliente]    CHAR (4)      NULL,
    [cd_telefone_contato]       VARCHAR (15)  NULL,
    [cd_fax_contato]            VARCHAR (15)  NULL,
    [cd_celular]                VARCHAR (15)  NULL,
    [cd_ramal]                  VARCHAR (10)  NULL,
    [cd_email_contato_cliente]  VARCHAR (100) NULL,
    [ds_observacao_contato]     TEXT          NULL,
    [cd_tipo_endereco]          INT           NULL,
    [cd_cargo]                  INT           NULL,
    [cd_acesso_cliente_contato] VARCHAR (10)  NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [cd_setor_cliente]          INT           NULL,
    [dt_nascimento]             DATETIME      NULL,
    [cd_departamento_cliente]   INT           NULL,
    [dt_nascimento_cliente]     DATETIME      NULL,
    [ic_status_contato_cliente] CHAR (1)      NULL,
    [ic_mala_direta_contato]    CHAR (1)      NULL,
    [ic_informativo_contato]    CHAR (1)      NULL,
    [ic_brinde_contato]         CHAR (1)      NULL,
    [cd_departamento]           INT           NULL,
    [dt_nascimento_contato]     DATETIME      NULL,
    [cd_tratamento_pessoa]      INT           NULL,
    [cd_nivel_decisao]          INT           NULL,
    [ic_status_contato]         CHAR (1)      NULL,
    [dt_status_contato]         DATETIME      NULL,
    [cd_ddd_celular]            VARCHAR (4)   NULL,
    [cd_ddi_contato_cliente]    CHAR (4)      NULL,
    [cd_ddi_celular]            VARCHAR (4)   NULL,
    [ic_nfe_contato]            CHAR (1)      NULL,
    [cd_controle]               INT           NULL,
    [ic_cobranca_contato]       CHAR (1)      NULL,
    CONSTRAINT [PK_Cliente_Contato] UNIQUE NONCLUSTERED ([cd_cliente] ASC, [cd_contato] ASC) WITH (FILLFACTOR = 90)
);


GO

create trigger dbo.pr_tg_deleta_codigo_cliente_contato 
on cliente_contato 
for insert

as

declare @cd_apresentado int 

        select @cd_apresentado = cd_contato 
        from cliente_contato

        exec egisAdmin.dbo.sp_liberacodigo
             'EGISSQL.DBO.cliente_contato', 
             @cd_apresentado,
             'D'          


