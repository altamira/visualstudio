CREATE TABLE [dbo].[Importador_Contato] (
    [cd_importador]          INT           NOT NULL,
    [cd_contato_importador]  INT           NOT NULL,
    [cd_tratamento]          INT           NULL,
    [nm_contato_importador]  VARCHAR (40)  NULL,
    [nm_fantasia_importador] VARCHAR (15)  NULL,
    [dt_nascimento_contato]  DATETIME      NULL,
    [cd_ddd_contato]         VARCHAR (4)   NULL,
    [cd_fone_contato]        VARCHAR (15)  NULL,
    [cd_ramal_contato]       VARCHAR (15)  NULL,
    [cd_celular_contato]     VARCHAR (15)  NULL,
    [ds_contato_importador]  TEXT          NULL,
    [nm_email_contato]       VARCHAR (100) NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    CONSTRAINT [PK_Importador_Contato] PRIMARY KEY CLUSTERED ([cd_importador] ASC, [cd_contato_importador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Importador_Contato_Tratamento_Pessoa] FOREIGN KEY ([cd_tratamento]) REFERENCES [dbo].[Tratamento_Pessoa] ([cd_tratamento])
);

