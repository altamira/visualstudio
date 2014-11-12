CREATE TABLE [dbo].[Tipo_Papel] (
    [cd_tipo_papel]           INT           NOT NULL,
    [nm_tipo_papel]           VARCHAR (30)  NULL,
    [sg_tipo_papel]           CHAR (2)      NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_departamento]         INT           NULL,
    [nm_documento_tipo_papel] VARCHAR (100) NULL,
    CONSTRAINT [PK_Tipo_Papel] PRIMARY KEY CLUSTERED ([cd_tipo_papel] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Papel_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);


GO
CREATE NONCLUSTERED INDEX [IX_Tipo_Papel]
    ON [dbo].[Tipo_Papel]([cd_tipo_papel] ASC) WITH (FILLFACTOR = 90);

