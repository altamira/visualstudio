CREATE TABLE [dbo].[Motivo_Alteracao_Pedido] (
    [cd_motivo_alteracao_ped] INT          NOT NULL,
    [nm_motivo_alteracao_ped] VARCHAR (30) NOT NULL,
    [sg_motivo_alteracao_ped] CHAR (1)     NOT NULL,
    [ic_motivo_alteracao]     CHAR (1)     NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [ic_motivo_alteracao_ped] CHAR (1)     NULL,
    CONSTRAINT [PK_Motivo_Alteracao_Pedido] PRIMARY KEY CLUSTERED ([cd_motivo_alteracao_ped] ASC) WITH (FILLFACTOR = 90)
);

