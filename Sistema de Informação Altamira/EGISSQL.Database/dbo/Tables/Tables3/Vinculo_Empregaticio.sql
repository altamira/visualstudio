CREATE TABLE [dbo].[Vinculo_Empregaticio] (
    [cd_vinculo_empregaticio] INT          NOT NULL,
    [nm_vinculo_empregaticio] VARCHAR (30) NOT NULL,
    [sg_vinculo_empregaticio] CHAR (10)    NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Vinculo_Empregaticio] PRIMARY KEY CLUSTERED ([cd_vinculo_empregaticio] ASC) WITH (FILLFACTOR = 90)
);

