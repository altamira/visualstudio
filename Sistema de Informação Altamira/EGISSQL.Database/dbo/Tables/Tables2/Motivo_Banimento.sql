CREATE TABLE [dbo].[Motivo_Banimento] (
    [cd_motivo_banimento] INT          NOT NULL,
    [nm_motivo_banimento] VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Banimento] PRIMARY KEY CLUSTERED ([cd_motivo_banimento] ASC)
);

