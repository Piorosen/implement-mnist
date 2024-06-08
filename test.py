#%%
import pyfiglet
import argparse

# %%
art = pyfiglet.figlet_format("IMPLEMENT MNIST", font="3d-ascii")
print(art)
for i in pyfiglet.FigletFont.getFonts():
    try:
        print(i)
        ASCII_art_1 = pyfiglet.figlet_format('oMFDOo Piorosen',font=i)
        print(ASCII_art_1)
        print()
    except:
        print(i)

# %%
