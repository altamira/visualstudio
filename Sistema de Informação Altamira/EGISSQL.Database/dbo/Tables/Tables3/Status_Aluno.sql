CREATE TABLE [dbo].[Status_Aluno] (
    [cd_status_aluno]       INT          NOT NULL,
    [nm_status_aluno]       VARCHAR (40) NULL,
    [sg_status_aluno]       VARCHAR (10) NULL,
    [ic_ativo_status_aluno] CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Status_Aluno] PRIMARY KEY CLUSTERED ([cd_status_aluno] ASC) WITH (FILLFACTOR = 90)
);

