CREATE TABLE [dbo].[Motivo_Devolucao_nota] (
    [cd_motivo_dev_nota] INT          NOT NULL,
    [nm_motivo_dev_nota] VARCHAR (40) NOT NULL,
    [sg_motivo_dev_nota] CHAR (10)    NOT NULL,
    [ic_motivo_dev_nota] CHAR (1)     NOT NULL,
    [cd_usuario]         INT          NOT NULL,
    [dt_usuario]         DATETIME     NOT NULL,
    CONSTRAINT [PK_Motivo_Devolucao_nota] PRIMARY KEY CLUSTERED ([cd_motivo_dev_nota] ASC) WITH (FILLFACTOR = 90)
);

