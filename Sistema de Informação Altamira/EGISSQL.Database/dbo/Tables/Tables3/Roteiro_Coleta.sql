CREATE TABLE [dbo].[Roteiro_Coleta] (
    [cd_roteiro_coleta]       INT          NOT NULL,
    [dt_roteiro_coleta]       DATETIME     NULL,
    [nm_roteiro_coleta]       VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_cliente]              INT          NULL,
    [ic_ativo_roteiro_coleta] CHAR (1)     NULL,
    CONSTRAINT [PK_Roteiro_Coleta] PRIMARY KEY CLUSTERED ([cd_roteiro_coleta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Roteiro_Coleta_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

