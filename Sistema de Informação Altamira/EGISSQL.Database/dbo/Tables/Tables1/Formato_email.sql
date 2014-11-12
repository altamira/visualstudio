CREATE TABLE [dbo].[Formato_email] (
    [cd_tipo_email]          INT          NOT NULL,
    [cd_email_item]          INT          NOT NULL,
    [cd_ordem_formato_email] INT          NOT NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_ativo_formato_email] CHAR (1)     NULL,
    [ds_formato_email]       TEXT         NULL,
    [nm_obs_formato_email]   VARCHAR (40) NULL,
    CONSTRAINT [PK_Formato_email] PRIMARY KEY CLUSTERED ([cd_tipo_email] ASC, [cd_email_item] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Formato_email_Email_item] FOREIGN KEY ([cd_email_item]) REFERENCES [dbo].[Email_item] ([cd_email_item])
);

