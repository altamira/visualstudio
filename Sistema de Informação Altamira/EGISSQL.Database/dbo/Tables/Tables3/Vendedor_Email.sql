CREATE TABLE [dbo].[Vendedor_Email] (
    [cd_vendedor]       INT           NOT NULL,
    [cd_email_vendedor] INT           NOT NULL,
    [nm_email_vendedor] VARCHAR (100) NULL,
    [ic_tipo_email]     CHAR (1)      NULL,
    [cd_usuario]        INT           NULL,
    [dt_usuario]        DATETIME      NULL,
    CONSTRAINT [PK_Vendedor_Email] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_email_vendedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vendedor_Email_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

