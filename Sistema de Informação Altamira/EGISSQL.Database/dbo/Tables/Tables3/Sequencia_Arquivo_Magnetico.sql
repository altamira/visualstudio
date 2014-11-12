CREATE TABLE [dbo].[Sequencia_Arquivo_Magnetico] (
    [cd_documento_magnetico] INT NOT NULL,
    [cd_ultimo_contador]     INT NOT NULL,
    CONSTRAINT [PK_Sequencia_Arquivo_Magnetico] PRIMARY KEY CLUSTERED ([cd_documento_magnetico] ASC, [cd_ultimo_contador] ASC) WITH (FILLFACTOR = 90)
);

