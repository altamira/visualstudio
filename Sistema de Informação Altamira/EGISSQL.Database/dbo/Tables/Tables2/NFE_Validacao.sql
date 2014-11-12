CREATE TABLE [dbo].[NFE_Validacao] (
    [cd_controle]           INT           NOT NULL,
    [dt_validacao]          DATETIME      NULL,
    [cd_usuario_validacao]  INT           NULL,
    [cd_tipo_validacao]     INT           NULL,
    [nm_validacao]          VARCHAR (60)  NULL,
    [cd_registro]           INT           NULL,
    [nm_fantasia]           VARCHAR (30)  NULL,
    [nm_registro_validacao] VARCHAR (60)  NULL,
    [cd_tabela]             INT           NULL,
    [ds_validacao]          VARCHAR (256) NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    CONSTRAINT [PK_NFE_Validacao] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90)
);

