CREATE TABLE [dbo].[Status_Atendimento] (
    [cd_status_atendimento] INT          NOT NULL,
    [nm_status_atendimento] VARCHAR (30) NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    [sg_status_atendimento] CHAR (10)    NULL,
    CONSTRAINT [PK_Status_Atendimento] PRIMARY KEY CLUSTERED ([cd_status_atendimento] ASC) WITH (FILLFACTOR = 90)
);

