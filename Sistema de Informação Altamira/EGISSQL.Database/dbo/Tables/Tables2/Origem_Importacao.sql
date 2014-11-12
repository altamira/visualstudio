CREATE TABLE [dbo].[Origem_Importacao] (
    [cd_origem_importacao]     INT          NOT NULL,
    [nm_origem_importacao]     VARCHAR (40) NOT NULL,
    [sg_origem_importacao]     CHAR (1)     NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ic_pad_origem_importacao] CHAR (1)     NULL,
    CONSTRAINT [PK_Origem_Importacao] PRIMARY KEY CLUSTERED ([cd_origem_importacao] ASC) WITH (FILLFACTOR = 90)
);

