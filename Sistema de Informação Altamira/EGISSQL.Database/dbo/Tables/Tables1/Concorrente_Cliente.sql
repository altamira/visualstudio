CREATE TABLE [dbo].[Concorrente_Cliente] (
    [cd_cliente]             INT          NOT NULL,
    [cd_cliente_concorrente] INT          NOT NULL,
    [nm_cliente_concorrente] VARCHAR (30) NOT NULL,
    [sg_cliente_concorrente] CHAR (10)    NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Concorrente_Cliente] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_cliente_concorrente] ASC) WITH (FILLFACTOR = 90)
);

