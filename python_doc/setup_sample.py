from setuptools import setup, find_packages

package_data = {
    '': ['*.txt', '*.md'],
    'my_package': ['data/*.dat', 'config/*.json'],
    'my_package.config': ['application*.yml']
}

setup(
    name="my_package",
    version="0.1.0",
    package=find_packages(),
    description='A sample Python package',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    author='euewrqe',
    author_email='euewrqe@example.com',
    url='',
    include_package_data=True,
    package_data=package_data,
    install_requires=[
        'pandas==1.5.3',
        'numpy==1.23.5',
        'scikit-learn==1.2.2',
        'scipy==1.10.1'
    ],
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent'
    ]
)