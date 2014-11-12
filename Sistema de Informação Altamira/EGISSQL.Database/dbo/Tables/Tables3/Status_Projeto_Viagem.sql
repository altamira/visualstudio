CREATE TABLE [dbo].[Status_Projeto_Viagem] (
    [cd_status_projeto]     INT          NOT NULL,
    [nm_status_projeto]     VARCHAR (30) NULL,
    [sg_status_projeto]     CHAR (5)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_pad_status_projeto] CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Projeto_Viagem] PRIMARY KEY CLUSTERED ([cd_status_projeto] ASC) WITH (FILLFACTOR = 90)
);

