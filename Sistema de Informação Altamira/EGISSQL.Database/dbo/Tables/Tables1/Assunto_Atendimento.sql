CREATE TABLE [dbo].[Assunto_Atendimento] (
    [cd_assunto_atendimento] INT          NOT NULL,
    [nm_assunto_atendimento] VARCHAR (40) NULL,
    [sg_assunto_atendimento] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Assunto_Atendimento] PRIMARY KEY CLUSTERED ([cd_assunto_atendimento] ASC) WITH (FILLFACTOR = 90)
);

