CREATE TABLE [dbo].[Motivo_Ativacao_Nota] (
    [cd_motivo_ativacao_nota] INT          NOT NULL,
    [nm_motivo_ativacao_nota] VARCHAR (40) NOT NULL,
    [sg_motivo_ativacao_nota] CHAR (10)    NOT NULL,
    [ic_motivo_ativacao_nota] CHAR (1)     NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Motivo_Ativacao_Nota] PRIMARY KEY CLUSTERED ([cd_motivo_ativacao_nota] ASC) WITH (FILLFACTOR = 90)
);

