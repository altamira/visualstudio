CREATE TABLE [dbo].[Consulta_Cliente_Origem] (
    [cd_consulta]       INT      NOT NULL,
    [cd_cliente_origem] INT      NOT NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    CONSTRAINT [PK_Consulta_Cliente_Origem] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_cliente_origem] ASC) WITH (FILLFACTOR = 90)
);

