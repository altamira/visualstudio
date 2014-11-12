CREATE TABLE [dbo].[Assunto_Viagem] (
    [cd_assunto_viagem]     INT          NOT NULL,
    [nm_assunto_viagem]     VARCHAR (30) NOT NULL,
    [sg_assunto_viagem]     CHAR (10)    NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    [ic_pad_assunto_viagem] CHAR (1)     NULL,
    CONSTRAINT [PK_Assunto_Viagem] PRIMARY KEY CLUSTERED ([cd_assunto_viagem] ASC) WITH (FILLFACTOR = 90)
);

