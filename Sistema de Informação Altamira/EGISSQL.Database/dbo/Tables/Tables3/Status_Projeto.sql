CREATE TABLE [dbo].[Status_Projeto] (
    [cd_status_projeto]     INT          NOT NULL,
    [nm_status_projeto]     VARCHAR (30) NOT NULL,
    [sg_status_projeto]     CHAR (5)     NOT NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_pad_status_projeto] CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Projeto] PRIMARY KEY NONCLUSTERED ([cd_status_projeto] ASC) WITH (FILLFACTOR = 90)
);

