CREATE TABLE [dbo].[Origem_Ocorrencia] (
    [cd_origem_ocorrencia] INT          NOT NULL,
    [nm_origem_ocorrencia] VARCHAR (40) NOT NULL,
    [sg_origem_ocorrencia] CHAR (10)    NOT NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Origem_Ocorrencia] PRIMARY KEY CLUSTERED ([cd_origem_ocorrencia] ASC) WITH (FILLFACTOR = 90)
);

