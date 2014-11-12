CREATE TABLE [dbo].[Seguradora_Contato] (
    [cd_seguradora]         INT           NOT NULL,
    [cd_contato_seguradora] INT           NOT NULL,
    [nm_contato_seguradora] VARCHAR (40)  NULL,
    [nm_fantasia_contato]   VARCHAR (15)  NULL,
    [dt_nascimento_contato] DATETIME      NULL,
    [cd_ddd_contato]        VARCHAR (4)   NULL,
    [cd_fone_contato]       VARCHAR (15)  NULL,
    [cd_ramal_contato]      VARCHAR (15)  NULL,
    [cd_celular_contato]    VARCHAR (15)  NULL,
    [ds_contato_seguradora] TEXT          NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    [nm_email_contato]      VARCHAR (100) NULL,
    CONSTRAINT [PK_Seguradora_Contato] PRIMARY KEY CLUSTERED ([cd_seguradora] ASC, [cd_contato_seguradora] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Seguradora_Contato_Seguradora] FOREIGN KEY ([cd_seguradora]) REFERENCES [dbo].[Seguradora] ([cd_seguradora])
);

