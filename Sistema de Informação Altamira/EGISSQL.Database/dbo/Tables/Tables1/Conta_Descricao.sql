CREATE TABLE [dbo].[Conta_Descricao] (
    [cd_empresa]      INT          NOT NULL,
    [cd_idioma]       INT          NOT NULL,
    [cd_conta]        INT          NOT NULL,
    [nm_conta_idioma] VARCHAR (40) NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Conta_Descricao] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_idioma] ASC, [cd_conta] ASC) WITH (FILLFACTOR = 90)
);

