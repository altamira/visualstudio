CREATE TABLE [dbo].[Motivo_Cancelamento_Nota] (
    [cd_motivo_canc_nota] INT          NOT NULL,
    [nm_motivo_canc_nota] VARCHAR (40) NOT NULL,
    [sg_motivo_canc_nota] CHAR (10)    NOT NULL,
    [ic_motivo_canc_nota] CHAR (1)     NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Motivo_Cancelamento_Nota] PRIMARY KEY CLUSTERED ([cd_motivo_canc_nota] ASC) WITH (FILLFACTOR = 90)
);

